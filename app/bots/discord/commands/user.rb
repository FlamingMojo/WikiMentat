# frozen_string_literal: true

module Discord::Commands
  module User
    extend ::Discord::CommandHandler

    # with_locale_context 'discord_bot.commands.user.tooltip'

    class << self
      def setup
        register_commands
        register_handlers
      end

      def register_commands
      end

      def register_handlers
        handle_button(/verify_board:link:/, 'Discord::Commands::User::Link')
        handle_modal(/verify_board:claim:/, 'Discord::Commands::User::Claim')
        # handle_button('verify_board:search', 'DiscordBot::Commands::User::Search')
        # handle_user_select('search:lookup', 'DiscordBot::Commands::User::Lookup')
        # handle_mention('DiscordBot::Commands::User::UploadImage')
      end
    end
  end
end
