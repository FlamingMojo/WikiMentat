# frozen_string_literal: true

# Invoked from manual submit button on mission cards
module Discord::Commands::Missions
  class Submit
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.submit'

    def content
      return t('not_found') unless mission
      return t('not_yours') if mission.assignee != mentat_member

      mission.submit

      t('manual_submit', summary: mission.summary)
    end

    private

    def mission
      @mission ||= Mission.find_by(id: custom_id.split(':').last)
    end
  end
end
