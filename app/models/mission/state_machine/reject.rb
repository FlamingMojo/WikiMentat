class Mission
  module StateMachine
    class Reject
      include ::Translatable
      attr_reader :mission, :feedback, :abandon
      private :mission, :feedback

      with_locale_context 'discord.commands.missions.reject'

      def initialize(mission:, feedback: nil)
        @mission = mission
        @feedback = feedback
        @abandon = false
      end

      def self.call(mission:, feedback: nil)
        new(mission:, feedback:).reject
      end

      def reject
        return abandon_mission if assignee.missions.accepted.count >= 1

        reject_mission
      end

      private

      def abandon_mission
        @abandon = true
        mission.abandon
        notify_user

        t('abandoned_mission', summary: mission.summary)
      rescue StandardError
        t('abandoned_mission_no_pm', summary: mission.summary)
      end

      def reject_mission
        mission.delete_post! && mission.accepted! && mission.reload && mission.sync_post!
        notify_user

        t('rejected_mission', summary: mission.summary)
      rescue StandardError
        t('rejected_mission_no_pm', summary: mission.summary)
      end

      def notify_user
        wiki_bot.notify_user(
          username: wiki_user.username,
          message: message(:wiki),
        )

        Discord.send_message(
          channel: Discord.pm_channel(assignee.discord_uid.to_i),
          content: message,
        ) unless wiki_user.dummy_user?
      end

      def message(platform = :discord)
        RejectMessage.new(mission:, feedback:, abandon:, platform:).message
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

      class RejectMessage
        include ::Translatable
        with_locale_context 'discord.commands.missions.reject'

        attr_reader :mission, :feedback, :abandon, :platform
        private :mission, :feedback, :abandon, :platform

        def initialize(mission:, feedback: nil, abandon: false, platform: :discord)
          @mission = mission
          @feedback = feedback
          @abandon = abandon
          @platform = platform
        end

        def message
          t(key, **{ summary:, current_mission:, link:, feedback: }.compact)
        end

        def key
          [
            'notification',
            abandon ? 'abandon' : 'rejected',
            platform,
            feedback ? 'feedback' : 'standalone'
          ].join('.')
        end

        def summary
          mission.summary
        end

        def current_mission
          return unless abandon
          new_mission = mission.assignee.current_mission
          return "[[Mentat:Missions/#{new_mission.id}|#{new_mission.summary}]]" unless discord?

          new_mission.summary
        end

        def link
          mission.reload.discord_post_link if discord?

          "[[Mentat:Missions/#{mission.id}|Mission #{mission.id}]]"
        end

        def discord?
          platform == :discord
        end
      end
    end
  end
end
