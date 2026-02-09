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
        Discord::Bot.slash_command(:mentat_admin, t('admin.tooltip.wiki_admin')) do |cmd|
          cmd.subcommand(:verify_board, t('admin.tooltip.verify_board'))
          # cmd.subcommand(:editor_board, t('editor_board'))
          # cmd.subcommand(:block_word, 'Add word to username blocklist') do |sub|
          #   sub.string('word', 'Word to block')
          # end
          # cmd.subcommand(:unblock_word, 'Remove word from username blocklist') do |sub|
          #   sub.string('word', 'Word to unblock')
          # end
        end
      end

      def register_handlers
        # handle_message('DiscordBot::Commands::Admin::AutoBlock')
        handle(:mentat_admin, :verify_board, 'Discord::Commands::Admin::VerifyBoard')
        # handle(:wiki_admin, :block_word, 'DiscordBot::Commands::Admin::AutoBlock::BlacklistWord')
        # handle(:wiki_admin, :unblock_word, 'DiscordBot::Commands::Admin::AutoBlock::WhitelistWord')
        handle_reaction('Discord::Commands::Admin::ReactionBlock', emoji: "❌")
        handle_reaction('Discord::Commands::Admin::ReactionUnblock', emoji: '✅')
        # handle_reaction('Discord::Commands::Admin::AutoBlock::BlacklistName', emoji: '⚠️')
      end
    end
  end
end
