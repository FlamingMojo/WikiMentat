# frozen_string_literal: true

# Invoked from admin slash command /post_mission
# Returns dropdown of mission types
module Discord::Commands::Missions
  class Init
    include Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.init'

    def content
      return t('../not_enabled') unless guild_config.enable_missions

      t('prompt')
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    def response_block
      return ->(_builder, _view) { } unless guild_config.enable_missions

      lambda do |_builder, view|
        view.row do |r|
          r.select_menu(custom_id: 'mission:new', placeholder: t('placeholder'), max_values: 1) do |s|
            Mission::TYPES.each do |type|
              s.option(label: t(type), value: type)
            end
          end
        end
      end
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
