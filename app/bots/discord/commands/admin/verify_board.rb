# frozen_string_literal: true

module Discord::Commands::Admin
  class VerifyBoard
    include ::Discord::Util

    def content
      return t('admin.verify_board.failure.no_access') unless mentat_member.admin?
      return t('admin.verify_board.failure.disabled', website: ENV['HOST_URL']) unless guild_configs.any?
      return t('admin.verify_board.failure.no_channels', website: ENV['HOST_URL']) unless channels.any?

      guild_configs.each do |guild_config|
        guild_config.verify_board_channels.each do |channel|
          wiki = guild_config.wiki
          create_params = { channel: channel.discord_uid, content: '', embeds: create_embed(wiki), components: buttons(wiki) }
          discord_message = Discord.send_message(**create_params)
          message = Message.create(message_type: :board_post, channel: channel, discord_uid: discord_message.id)
          Board.create(board_type: :verify_board, message: message, guild: channel.guild, wiki: guild_config.wiki)
        end
      end

      t('admin.verify_board.success')
    end

    private

    def buttons(wiki)
      ::Discordrb::Components::View.new do |builder|
        builder.row do |row|
          row.button(label: t('admin.verify_board.link'), custom_id: "verify_board:link:#{wiki.id}", style: :primary)
          row.button(
            label: t('admin.verify_board.lookup'), custom_id: "verify_board:search::#{wiki.id}", style: :secondary
          )
        end
      end
    end

    def create_embed(wiki)
      Embed.generate(wiki)
    end

    def channels
      guild_configs.map(&:verify_board_channels)
    end

    def guild_configs
      @guild_configs ||= guild.guild_configs.where(wiki_user_verification: true)
    end

    class Embed
      include ::Discord::Util
      attr_reader :wiki
      private :wiki

      def initialize(wiki)
        @wiki = wiki
      end

      def self.generate(wiki)
        new(wiki).generate
      end

      def generate
        embed.title = t('admin.verify_board.embed.title', wiki: wiki.name)
        embed.colour = 0xf58a04
        embed.description = t('admin.verify_board.embed.description')
        embed.thumbnail = thumbnail if wiki.logo_url

        embed
      end

      private

      def thumbnail
        Discordrb::Webhooks::EmbedThumbnail.new(url: wiki.logo_url)
      end

      def embed
        @embed ||= Discordrb::Webhooks::Embed.new
      end
    end
  end
end
