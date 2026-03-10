# frozen_string_literal: true

class Mission < ActiveRecord::Base
  # Allow us to use the :type field.
  Mission.inheritance_column = nil

  def self.ransackable_attributes(auth_object = nil)
    %w[
      assignee_id completed_at created_at description discord_post_link discord_post_uid guild_config_id id
      issuer_id language map_link priority status title type updated_at wiki_page
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[assignee guild guild_config image_mission_rule image_rule issuer wiki]
  end

  include ::Translatable

  with_locale_context 'mission'

  # Add page_translate when ready
  TYPES = %w[page_create page_update image_upload].freeze
  STATES = %w[active accepted submitted completed].freeze

  enum :status, STATES.map { |k| [ k.to_sym, k ] }.to_h
  enum :type, TYPES.map { |k| [ k.to_sym, k ] }.to_h
  enum :priority, %w[low medium high].map { |k| [ k.to_sym, k ] }.to_h

  belongs_to :guild_config, inverse_of: :missions, required: true
  has_one :wiki, through: :guild_config
  has_one :guild, through: :guild_config
  belongs_to :issuer, class_name: 'Member', required: true
  belongs_to :assignee, class_name: 'Member', optional: true
  has_one :image_mission_rule, dependent: :destroy
  has_one :image_rule, through: :image_mission_rule

  scope :in_progress, -> { where(status: %w[active accepted submitted]) }

  validates :title, presence: true
  validates :description, presence: true
  validate :wiki_page_must_be_valid_wiki_url
  validate :map_link_must_be_valid_wiki_url

  def wiki_page_must_be_valid_wiki_url
    return if wiki_page.blank? || wiki_page.match(/\A#{wiki.url}\//i)

    errors.add(:wiki_page, 'must be a valid wiki page')
  end

  def map_link_must_be_valid_wiki_url
    return if map_link.blank? || map_link.match(/\A#{wiki.url}\//i)

    errors.add(:map_link, 'must be a valid wiki page')
  end

  def colour
    return 0x000000 unless state_default

    state_default.colour
  end

  def thumbnail
    return unless type_default

    type_default.thumbnail
  end

  def type_default
    guild_config.type_defaults.find_by(name: type)
  end

  def state_default
    guild_config.state_defaults.find_by(name: status)
  end

  def context
    return :live if active? || accepted?
    return :archive if completed?

    :admin
  end

  def rule=(rule_name)
    return unless rule_name

    image_mission_rule = ImageMissionRule.new(
      mission: self, image_rule: guild_config.image_rules.find_by(name: rule_name)
    )
  end

  def accept(user)
    update(assignee: user, status: 'accepted') && sync_post!
  end

  def submit
    delete_post! && submitted! && reload && sync_post!
  end

  def abandon
    delete_post! && update(assignee: nil, status: 'active') && reload && sync_post!
  end

  def cancel
    delete_post! && update(assignee: nil, status: 'completed', title: "[CANCELLED] #{title}") && reload && sync_post!
  end

  def reject
    delete_post! && accepted! && reload && sync_post!
  end

  def approve
    completed! && reload && sync_post!
  end

  def delete_post!
    return unless discord_post_uid

    post.delete && update(discord_post_uid: nil, discord_post_link: nil)
  end

  def sync_post!
    return post.update if discord_post_uid

    post_message = post.create
    update(
      discord_post_uid: post_message.id,
      discord_post_link: t('link', guild_id: guild.discord_uid, message_id: post_message.id, channel_id: post.channel)
    )
  end

  def embed
    Embed.generate(self)
  end

  def post
    Post.new(reload)
  end

  def display_attributes
    attributes.merge('wiki_page_md' => wiki_page_md, 'map_link_md' => map_link_md)
  end

  def wiki_page_md
    format_link(wiki_page)
  end

  def map_link_md
    format_link(map_link)
  end

  def format_link(link)
    return unless link
    "[#{link.split("/").last.split("?").first.gsub("_", " ")}](#{link})"
  end

  def instructions
    params = display_attributes.slice(*I18n.interpolation_keys("mission.instructions.#{type}")).symbolize_keys
    t("instructions.#{type}", **params)
  end

  def summary
    "[#{id}] #{title}"
  end

  def channel_uid
    discord_post_link.gsub('https://discord.com/channels/', '').split('/')[1]
  end
end
