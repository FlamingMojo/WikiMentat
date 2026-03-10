# frozen_string_literal: true

# Invoked from Submit embed buttons
# Completes the mission
# Rewards the user
# Deletes mission post
# Updates submit embed to remove buttons and update status
module Discord::Commands::Missions
  class Approve
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.approve'

    def content
      return t('not_found') unless mission
      return t('not_submitted') unless mission.submitted?
      return t('not_assigned') unless assignee

      mission.approve
      Discord.send_message(
        channel: notifications_channel.discord_uid,
        content: t('celebration', user: assignee.discord_uid, summary: mission.summary, count: mission_count)
      )
      handle_reward

      t('approved_mission', summary: mission.summary)
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    private

    def handle_reward
      return unless guild_config.enable_rewards
      return unless reward_types.map(&:threshold).include?(mission_count)
      return out_of_stock unless reward_type_due.in_stock?

      member_reward
      Discord.send_message(
        channel: admin_channel.discord_uid,
        content: t('reward', user: assignee.discord_uid, count: mission_count, reward: reward_type_due.name),
        components: confirm_button,
      )
    end

    def reward_types
      @reward_types ||= guild_config.reward_types.mission_count
    end

    def reward_type_due
      @reward_type_due ||= reward_types.find_by(threshold: mission_count)
    end

    def out_of_stock
      Discord.send_message(
        channel: admin_channel.discord_uid,
        content: t('reward_out_of_stock', user: assignee.discord_uid, reward: reward_type_due.name)
      )
    end

    def member_reward
      @member_reward ||= reward_type_due.next_reward.issue_to(assignee)
    end

    def confirm_button
      ::Discordrb::Components::View.new do |builder|
        builder.row do |row|
          row.button(label: t('confirm'), custom_id: "mission:reward:confirm:#{member_reward.id}", style: :success)
        end
      end
    end

    def mission_count
      @mission_count ||= assignee.reload.missions.completed.count
    end

    def assignee
      @assignee ||= mission.assignee
    end

    def mission
      @mission ||= guild_config.missions.find_by(id: custom_id.split(':').last)
    end

    def admin_channel
      @admin_channel ||= guild_config.mission_admin_channel
    end

    def notifications_channel
      @notifications_channel ||= guild_config.mission_notifications_channel
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
