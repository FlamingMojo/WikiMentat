# frozen_string_literal: true

module Discord::Commands::Missions
  class ManuallyReward
    include Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.manually_reward'

    def content
      return t('not_enabled') unless guild_config.enable_rewards
      return t('not_found') unless assignee
      return out_of_stock unless reward_type_due.in_stock?

      member_reward
      Discord.send_message(
        channel: admin_channel.discord_uid,
        content: t('reward', user: assignee.discord_uid, reward: reward_type_due.name, admin: user.id),
        components: confirm_button,
      )

      t('issued')
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    private

    def reward_type_due
      # Temporary - Hardcode to the first reward type
      @reward_type_due ||= guild_config.reward_types.first
    end

    def assignee
      @assignee ||= guild.find_member_by_discord_uid(user_id)
    end

    def user_id
      event.options['target_user'].to_s
    end

    def out_of_stock
      Discord.send_message(
        channel: admin_channel.discord_uid,
        content: t('reward_out_of_stock', user: assignee.discord_uid, reward: reward_type_due.name)
      )
    end

    def member_reward
      @member_reward ||= reward_type_due.next_reward.issue_to(assignee, issue_type: :manual)
    end

    def confirm_button
      ::Discordrb::Components::View.new do |builder|
        builder.row do |row|
          row.button(label: t('confirm'), custom_id: "mission:reward:confirm:#{user_reward.id}", style: :success)
        end
      end
    end

    def admin_channel
      @admin_channel ||= guild_config.mission_admin_channel
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
