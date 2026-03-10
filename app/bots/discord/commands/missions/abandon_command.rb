# frozen_string_literal: true

# Invoked from user command
# Check user has any assigned missions, if not, warn.
# Remove user from assigned mission
# Update mission to active, update embed and buttons.
module Discord::Commands::Missions
  class AbandonCommand
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.abandon'

    def content
      return t('../not_enabled') unless guild_config.enable_missions
      return t('not_found') unless mission

      mission.abandon

      t('abandoned_mission', summary: mission.summary)
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    private

    def mission
      @mission ||= mentat_member.current_mission
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
