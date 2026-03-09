class GuildConfig
  module MissionChannels
    extend ActiveSupport::Concern

    ConfiguredChannel::MISSION_CHANNELS.each do |channel_purpose|
      define_method("#{channel_purpose}_channel") do
        return unless enable_missions

        configured_channels.find_by(channel_purpose:).channel
      end
    end
  end
end
