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
        return unless reward_types.any? && reward_types_due.any?
        check_stock

        reward_types_due.each do |reward_type|
          member_reward = reward_type.next_reward.issue_to(assignee)

          Discord.send_message(
            channel: admin_channel.discord_uid,
            content: t('reward', user: assignee.discord_uid, reward: reward_type.name),
            components: confirm_button(member_reward),
          )
        end
      end

      def check_stock
        @reward_types_due = reward_types_due.map do |reward_type|
          next reward_type if reward_type.in_stock?

          out_of_stock(reward_type)
          nil
        end.compact
      end

      def out_of_stock(reward_type_due)
        Discord.send_message(
          channel: admin_channel.discord_uid,
          content: t('reward_out_of_stock', user: assignee.discord_uid, reward: reward_type_due.name)
        )
      end

      def confirm_button(member_reward)
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
          message: t(
            'celebration_content',
            summary: "[[Mentat:Missions/#{mission.id}|#{mission.summary}]]",
            count: mission_count
          ),
        )
      end

      def reward_types
        @reward_types ||= RewardType.available_for(assignee)
      end

      def reward_types_due
        @reward_types_due ||= reward_types.select { |reward_type| reward_type.check(assignee) }
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
