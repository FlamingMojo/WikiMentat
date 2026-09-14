class GuildConfig
  class ConfiguredChannel < ApplicationRecord
    self.table_name = 'configured_channels'

    def self.ransackable_attributes(auth_object = nil)
      %w[channel_id channel_purpose channel_mission_type created_at guild_config_id id updated_at]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[channel guild_config]
    end

    GENERAL_CHANNELS = %i[update_feed verify_boards].freeze
    MISSION_CHANNELS = %i[
      mission_board mission_in_progress mission_submissions mission_completed mission_notifications mission_admin
    ].freeze
    CHANNEL_MISSION_TYPES = [ :all_types, *Mission::TYPES_SYM ].freeze
    enum :channel_purpose, [ *GENERAL_CHANNELS, *MISSION_CHANNELS ], default: :update_feeds
    enum :channel_mission_type, CHANNEL_MISSION_TYPES, default: :all_types

    belongs_to :guild_config
    belongs_to :channel

    validates :channel_id, uniqueness: { scope: %i[guild_config_id channel_purpose channel_mission_type] }
  end
end
