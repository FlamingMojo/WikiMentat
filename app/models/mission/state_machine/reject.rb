class Mission
  module StateMachine
    class Reject
      include ::Translatable
      attr_reader :mission
      private :mission

      with_locale_context 'discord.commands.missions.reject'

      def initialize(mission)
        @mission = mission
      end

      def self.call(mission)
        new(mission).reject
      end

      def reject
        notify_feedback
        pm_feedback
        return abandon if assignee.missions.accepted.count >= 1
        mission.delete_post! && mission.accepted! && mission.reload && mission.sync_post!
        t('rejected_mission', summary: mission.summary)
      end

      private

      def abandon
        mission.abandon
        Discord.send_message(
          channel: Discord.pm_channel(assignee.discord_uid.to_i),
          content: abandon_pm_message
        )

        t('rejected_abandoned_mission', summary: mission.summary)
      end

      def abandon_pm_message
        t(
          'abandon',
          current_mission: assignee.current_mission.summary,
          summary: mission.summary,
          link: mission.reload.discord_post_link
        )
      end

      def pm_feedback
        Discord.send_message(
          channel: Discord.pm_channel(assignee.discord_uid.to_i),
          content: t('feedback', summary: mission.summary)
        )
      end

      def notify_feedback
        wiki_bot.notify_user(
          username: wiki_user.username,
          header: t('rejected_mission_subject'),
          content: t('feedback', summary: mission.summary),
          page: "Mentat:Mission/#{mission.id}"
        )
      end

      def wiki_user
        @wiki_user ||= assignee.wiki_user_for(guild_config.wiki)
      end

      def wiki_bot
        @wiki_bot ||= guild_config.wiki_bot
      end

      def guild_config
        @guild_config ||= mission.guild_config
      end

      def assignee
        @assignee ||= mission.assignee
      end
    end
  end
end
