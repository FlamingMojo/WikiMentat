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
  include Mission::Postable
  include Mission::StateMachine

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
  scope :for_user, ->(user) { joins(:guild_config).where(guild_config: { guild_id: user.guilds.pluck(:id) }) }

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

  def summary
    "[#{id}] #{title}"
  end

  def as_json(options = nil)
    rule = image_rule_id ? image_rule.name : nil
    assignee_uid = assignee_id ? assignee.discord_uid : nil
    {
      id:, guild_config_id:, status:, type:, title:, description:, wiki_page:, map_link:,
      discord_post_uid:, discord_post_link:, rule:, issuer: issuer.discord_uid,
      assignee: assignee_uid,
    }
  end
end
