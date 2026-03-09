# frozen_string_literal: true

# Invoked from mission post button from Create
# Updates embed/buttons on mission post
# Returns message to user
module Discord::Commands::Missions
  class Accept
    include Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.accept'

    def content
      return t('not_found') unless mission
      return t('must_verify') unless wiki_users.any?
      return t('already_on_mission', summary: mentat_member.current_mission.summary) if mentat_member.current_mission

      mission.accept(mentat_member)

      t('accepted_mission', summary: mission.summary, instructions: mission.instructions)
    end

    def mission
      @mission ||= Mission.find_by(id: custom_id.split(':').last)
    end

    def wiki_users
      @wiki_users ||= mentat_user.wiki_users.where(wiki: guild_config.wiki)
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
