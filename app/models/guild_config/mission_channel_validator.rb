class GuildConfig
  class MissionChannelValidator < ActiveModel::Validator
    def validate(record)
      return unless record.enable_missions

      ConfiguredChannel::MISSION_CHANNELS.each do |channel_purpose|
        # Either an :all channel OR one for each mission type
        next if record.configured_channels.exists?(channel_purpose:, channel_mission_type: :all)
        Mission::TYPES_SYM.all? do |channel_mission_type|
          record.configured_channels.exists?(channel_purpose:, channel_mission_type:)
        end

        record.errors.add(
          :enable_missions,
          "Missions requires a #{channel_purpose.to_s.titleize} Channel to be configured for all mission types"
        )
      end
    end
  end
end
