# frozen_string_literal: true

class Mission
  class Post
    include ::Translatable

    with_locale_context 'mission.post'

    attr_reader :mission
    private :mission

    def initialize(mission)
      @mission = mission
    end

    def create
      Discord.send_message(channel:, content:, embeds: mission.embed, components: buttons)
    end

    def update
      return move if mission.channel_uid != channel

      Discord.update_message(
        channel: mission.channel_uid, message: mission.discord_post_uid, content: content,
        embeds: [ mission.embed ], components: buttons.to_a
      )
    end

    def move
      delete
      post_message = create
      mission.update(
        discord_post_uid: post_message.id,
        discord_post_link: t('link', guild_id:, message_id: post_message.id, channel:)
      )
    end

    def delete
      Discord.delete_message(channel: mission.channel_uid, message: mission.discord_post_uid)
    end

    def channel
      return mission_board_channel.discord_uid if mission.active?
      return mission_in_progress_channel.discord_uid if mission.accepted?
      return mission_submissions_channel.discord_uid if mission.submitted?
      return mission_completed_channel.discord_uid if mission.completed?

      mission_board_channel.discord_uid
    end

    def content
      return '' unless context == :admin

      t('admin_notification')
    end

    def buttons
      return [] unless active_buttons.any?

      ::Discordrb::Components::View.new do |builder|
        builder.row do |row|
          active_buttons.each do |button|
            row.button(**button)
          end
        end
      end
    end

    def active_buttons
      return [ accept_button ] if mission.active?
      return [ abandon_button ] if mission.accepted?
      return [ approve_button, reject_button ] if mission.submitted?

      []
    end

    def accept_button
      {
        label: t('accept_mission'),
        custom_id: "mission:accept:#{mission.id}",
        style: :success,
        disabled: !mission.active?,
      }
    end

    def abandon_button
      {
        label: t('abandon_mission'),
        custom_id: "mission:abandon:#{mission.id}",
        style: :danger,
        disabled: !mission.accepted?,
      }
    end

    def approve_button
      {
        label: t('approve_mission'),
        custom_id: "mission:approve:#{mission.id}",
        style: :success,
        disabled: !mission.submitted?,
      }
    end

    def reject_button
      {
        label: t('reject_mission'),
        custom_id: "mission:reject:#{mission.id}",
        style: :danger,
        disabled: !mission.submitted?,
      }
    end

    def guild_id
      guild_config.guild.discord_uid
    end

    def context
      @context ||= mission.context
    end

    def guild_config
      @guild_config ||= mission.guild_config
    end

    GuildConfig::ConfiguredChannel::MISSION_CHANNELS.each do |channel_purpose|
      define_method("#{channel_purpose}_channel") do
        guild_config.configured_channels.find_by(channel_purpose:).channel
      end
    end
  end
end
