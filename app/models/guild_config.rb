class GuildConfig < ApplicationRecord
  after_create :setup_default_settings, unless: :already_setup?

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at guild_id wiki_id id wiki_prefix send_discord_messages bot_changes minor_changes null_changes
      suppress_previews max_characters max_username_characters prepend_timestamp use_emojis updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[guild wiki]
  end

  belongs_to :guild
  belongs_to :wiki
  has_many :disabled_hooks, dependent: :destroy
  has_many :hook_emojis, dependent: :destroy
  has_many :disabled_users, dependent: :destroy
  has_many :configured_channels, dependent: :destroy
  has_many :configured_feed_channels, -> { update_feed }, class_name: 'GuildConfig::ConfiguredChannel'
  has_many :feed_channels, through: :configured_feed_channels, source: :channel

  accepts_nested_attributes_for :disabled_hooks, allow_destroy: true
  accepts_nested_attributes_for :hook_emojis, allow_destroy: true
  accepts_nested_attributes_for :disabled_users, allow_destroy: true
  accepts_nested_attributes_for :configured_channels, allow_destroy: true

  def already_setup?
    hook_emojis.any? || configured_channels.any? || disabled_hooks.any? || disabled_users.any?
  end

  def setup_default_settings
    GuildConfig::HookEmoji.setup_default_emojis(self)
    # Some defaults require the record to be persisted
    disabled_users.find_or_create_by(wiki_user: wiki.wiki_users.find_or_create_by(username: 'Redirect fixer'))
  end

  def disabled?(webhook)
    return true if configured_channels.update_feed.none?
    return true if disabled_hook_type?(webhook)
    return true if disabled_user?(webhook)
    return true if !bot_changes && webhook.user.bot
    return true if !minor_changes? && webhook.page.minor_change?

    false
  end

  def emoji_for(webhook)
    return unless use_emojis?

    hook_emojis.find_by(hook_name: webhook.hook_type).tag
  end

  def disabled_hook_type?(webhook)
    disabled_hooks.exists?(hook_name: webhook.hook_type)
  end

  def disabled_user?(webhook)
    disabled_users.exists?(wiki_user: webhook.wiki_user)
  end

  def update_feeds
    feed_channels.map(&:discord_uid).map(&:to_i)
  end
end
