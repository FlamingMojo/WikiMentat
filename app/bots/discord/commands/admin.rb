# frozen_string_literal: true

module Discord::Commands
  module Admin
    extend ::Discord::CommandHandler

    # with_locale_context 'discord_bot.commands.admin.tooltip'

    class << self
      def setup
        register_commands
        register_handlers
      end

      def register_commands
        # Not ready yet
        # DiscordBot.slash_command(:wiki_admin, t('wiki_admin')) do |cmd|
        #   cmd.subcommand(:verify_board, t('verify_board'))
        #   cmd.subcommand(:editor_board, t('editor_board'))
        #   cmd.subcommand(:block_word, 'Add word to username blocklist') do |sub|
        #     sub.string('word', 'Word to block')
        #   end
        #   cmd.subcommand(:unblock_word, 'Remove word from username blocklist') do |sub|
        #     sub.string('word', 'Word to unblock')
        #   end
        # end
      end

      def register_handlers
        # handle_message('DiscordBot::Commands::Admin::AutoBlock')
        # handle(:wiki_admin, :verify_board, 'DiscordBot::Commands::Admin::VerifyBoard')
        # handle(:wiki_admin, :block_word, 'DiscordBot::Commands::Admin::AutoBlock::BlacklistWord')
        # handle(:wiki_admin, :unblock_word, 'DiscordBot::Commands::Admin::AutoBlock::WhitelistWord')
        handle_reaction('Discord::Commands::Admin::ReactionBlock', emoji: "❌")
        handle_reaction('Discord::Commands::Admin::ReactionUnblock', emoji: '✅')
        # handle_reaction('Discord::Commands::Admin::AutoBlock::BlacklistName', emoji: '⚠️')
      end
    end
  end
end
