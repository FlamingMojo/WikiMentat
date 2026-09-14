class GuildConfig
  module MissionChannels
    extend ActiveSupport::Concern

    ConfiguredChannel::MISSION_CHANNELS.each do |channel_purpose|
      define_method("#{channel_purpose}_channel") do
        return unless enable_missions

        configured_channels.find_by(channel_purpose:, channel_mission_type: :all_types).channel
      end
    end

    ConfiguredChannel::MISSION_CHANNELS.each do |channel_purpose|
      Mission::TYPES_SYM.each do |channel_mission_type|
        define_method("#{channel_purpose}_#{channel_mission_type}_channel") do
          return unless enable_missions

          specific_channel = configured_channels.find_by(channel_purpose:, channel_mission_type:)&.channel

          specific_channel || send(send("#{channel_purpose}_channel"))
        end
      end
    end
  end
end
