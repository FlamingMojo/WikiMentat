class GuildConfig
  class ConfiguredChannel < ApplicationRecord
    self.table_name = 'configured_channels'

    def self.ransackable_attributes(auth_object = nil)
      %w[channel_id channel_purpose created_at guild_config_id id updated_at]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[channel guild_config]
    end

    enum :channel_purpose, %i[update_feed]

    belongs_to :guild_config
    belongs_to :channel

    validates :channel_id, uniqueness: { scope: %i[guild_config_id channel_purpose] }
  end
end
