# frozen_string_literal: true

# Invoked from Submit embed buttons
# Sets mission back to accepted
# DM's user
# Updates submit embed to remove buttons and update status
module Discord::Commands::Missions
  class Reject
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.reject'

    def content
      return t('not_found') unless mission
      return t('not_submitted') unless mission.submitted?
      return t('not_assigned') unless assignee

      mission.reject
      send_pm(user_id: mission.assignee.discord_uid.to_i, message: t('feedback', summary: mission.summary))

      # Catch the edge case where a user has picked up another mission while awaiting this being accepted.
      return abandon_mission if assignee.reload.current_mission

      t('rejected_mission', summary: mission.summary)
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
      t('rejected_mission_no_feedback', summary: mission.summary)
    end

    private

    def abandon_mission
      mission.abandon
      send_pm(user_id: assignee.discord_uid.to_i, message: abandon_pm_message)

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

    def assignee
      @assignee ||= mission.assignee
    end

    def mission
      @mission ||= Mission.find_by(id: custom_id.split(':').last)
    end
  end
end
