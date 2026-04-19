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
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
      t('rejected_mission_no_feedback', summary: mission.summary)
    end

    private

    def mission
      @mission ||= Mission.find_by(id: custom_id.split(':').last)
    end
  end
end
