module API::V1
  class GuildConfigsController < APIController
    def index
      if guild_configs.any?
        handle_response(guild_configs)
      else
        handle_response({ error: 'No guild configs found.' }, status: 404)
      end
    end

    private

    def guild_configs
      @guild_configs ||= guilds.flat_map(&:guild_configs).map do |guild_config|
        { id: guild_config.id, wiki: guild_config.wiki.name, guild: guild_config.guild.name }
      end
    end

    def guilds
      @current_user.guilds
    end
  end
end
