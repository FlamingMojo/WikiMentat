# frozen_string_literal: true

# Invoked from admin command
# Finds mission by ID. If submitted/completed, warn
# Completes the mission
# If any assignee, DM's them and removes them
# Deletes mission post
module Discord::Commands::Missions
  class Cancel
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.cancel'

    def content
      return t('../not_enabled') unless guild_config.enable_missions
      return t('not_found') unless mission

      mission.cancel

      t('cancelled_mission', summary: mission.summary)
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    private

    def mission
      @mission ||= Mission.find_by(id: event.options['id'])
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
