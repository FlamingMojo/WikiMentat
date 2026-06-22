# frozen_string_literal: true

module Discord::Commands
  module User
    extend ::Discord::CommandHandler
    include ::Translatable

    with_locale_context 'discord.commands.user.tooltip'

    class << self
      def setup
        register_commands
        register_handlers
      end

      def register_commands
        Discord::Bot.slash_command(:front_or_back, 'Start Front or Back')
      end

      def register_handlers
        handle_button(/verify_board:link:/, 'Discord::Commands::User::Link')
        handle_modal(/verify_board:claim:/, 'Discord::Commands::User::Claim')
        handle_button(/verify_board:search:/, 'Discord::Commands::User::Search')
        handle_user_select(/search:lookup/, 'Discord::Commands::User::Lookup')
        handle_mention('Discord::Commands::User::UploadImage')
        handle_member_join('Discord::Commands::User::Join')
        # TEMP WIKI COMMANDS
        handle_command(:front_or_back, 'Discord::Commands::User::FrontOrBack')
        handle_button(/left:/, 'Discord::Commands::User::Left')
        handle_button(/right:/, 'Discord::Commands::User::Right')
        handle_button(/skip:/, 'Discord::Commands::User::Skip')
        handle_button(/problem:/, 'Discord::Commands::User::Problem')
        handle_button('front_or_back', 'Discord::Commands::User::Retry')
      end
    end
  end
end
