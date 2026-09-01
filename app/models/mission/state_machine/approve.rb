class Mission
  module StateMachine
    class Approve
      include ::Translatable
      attr_reader :mission
      private :mission

      with_locale_context 'discord.commands.missions.approve'

      def initialize(mission)
        @mission = mission
      end

      def self.call(mission)
        new(mission).approve
      end

      def approve
        mission.completed! && mission.reload && mission.sync_post!
        celebrate
        notify_celebration
        handle_reward
        t('approved_mission', summary: mission.summary)
      end

      private

      def celebrate
        Discord.send_message(
          channel: notifications_channel.discord_uid,
          content: t('celebration', user: assignee.discord_uid, summary: mission.summary, count: mission_count)
        )
      end

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
            row.button(
              label: t('confirm'), custom_id: "mission:reward:confirm:#{member_reward.id}", style: :success
            )
          end
        end
      end

      def notify_celebration
        wiki_bot.notify_user(
          username: wiki_user.username,
          header: t('approved_mission_subject'),
          content: t('celebration_content', summary: mission.summary, count: mission_count),
          page: "Mentat:Mission/#{mission.id}"
        )
      end

      def wiki_user
        @wiki_user ||= assignee.wiki_user_for(guild_config.wiki)
      end

      def wiki_bot
        @wiki_bot ||= guild_config.wiki_bot
      end

      def mission_count
        @mission_count ||= assignee.reload.missions.completed.count
      end

      def assignee
        @assignee ||= mission.assignee
      end

      def admin_channel
        @admin_channel ||= guild_config.mission_admin_channel
      end

      def notifications_channel
        @notifications_channel ||= guild_config.mission_notifications_channel
      end

      def guild_config
        @guild_config ||= mission.guild_config
      end
    end
  end
end
