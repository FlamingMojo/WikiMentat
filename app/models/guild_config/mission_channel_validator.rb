class GuildConfig
  class MissionChannelValidator < ActiveModel::Validator
    def validate(record)
      return unless record.enable_missions

      ConfiguredChannel::MISSION_CHANNELS.each do |channel_purpose|
        next if record.configured_channels.exists?(channel_purpose:)

        record.errors.add(
          :enable_missions,
          "Missions requires a #{channel_purpose.to_s.titleize} Channel to be configured"
        )
      end
    end
  end
end
