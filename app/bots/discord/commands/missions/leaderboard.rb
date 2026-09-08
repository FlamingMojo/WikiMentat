# frozen_string_literal: true

module Discord::Commands::Missions
  class Leaderboard
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.leaderboard'

    def content
      return t('../not_enabled') unless guild_config.enable_missions

      nil
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    def ephemeral
      false
    end

    def embed
      Embed.generate(guild_config)
    end
  end
end
