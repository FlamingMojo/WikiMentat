# frozen_string_literal: true

module Discord::Commands
  module Custom
    extend ::Discord::CommandHandler
    include ::Translatable

    SERVERS = {
       'AwakeningWiki' => 1204923645705855108,
    }

    with_locale_context 'discord.commands.custom.tooltip'

    class << self
      def setup
        register_commands
        register_handlers
      end

      def register_commands
        Discord::Bot.slash_command(:front_or_back, 'Start Front or Back', server_id: SERVERS['AwakeningWiki'])
      end

      def register_handlers
        handle_command(:front_or_back, 'Discord::Commands::Custom::AwakeningWiki::FrontOrBack')
        handle_button(/left:/, 'Discord::Commands::Custom::AwakeningWiki::Left')
        handle_button(/right:/, 'Discord::Commands::Custom::AwakeningWiki::Right')
        handle_button(/skip:/, 'Discord::Commands::Custom::AwakeningWiki::Skip')
        handle_button(/problem:/, 'Discord::Commands::Custom::AwakeningWiki::Problem')
        handle_button('front_or_back', 'Discord::Commands::Custom::AwakeningWiki::Retry')
        handle_mention('Discord::Commands::Custom::AwakeningWiki::RainOfBlood')
      end
    end
  end
end
