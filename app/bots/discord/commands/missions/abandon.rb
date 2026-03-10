# frozen_string_literal: true

# Invoked from Abandon button
# Check user has any assigned missions, if not, warn.
# Remove user from assigned mission
# Update mission to active, update embed and buttons.
module Discord::Commands::Missions
  class Abandon
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.abandon'

    def content
      return t('not_yours') if mission.assignee != mentat_member

      mission.abandon

      t('abandoned_mission', summary: mission.summary)
    end

    private

    def mission
      @mission ||= Mission.find_by(id: custom_id.split(':').last)
    end
  end
end
