module Webhooks
  class DiscordChannelMessage
    include DiscordUtils

    attr_reader :webhook, :guild_config
    private :webhook, :guild_config

    def initialize(webhook:, guild_config:)
      @webhook = webhook
      @guild_config = guild_config
    end

    # Re-implements all the webhooks from [mw-discord](https://github.com/jayktaylor/mw-discord)
    def perform
      return if disabled?

      guild_config.update_feeds.each do |channel|
        message = Discord.send_message(channel: channel.discord_uid, content:)
        webhook.update(message: Message.create(webhook:, channel:, content:, discord_uid: message.id))
      end
    rescue => e
      short_message = e.message.truncate(1000)
      Discord.send_message(
        channel: ENV['ERROR_LOG_CHANNEL'],
        content: "⚠️[#{webhook.id}](#{ENV['HOST_URL']}/admin/webhooks/#{webhook.id}) ERROR: ```#{short_message}```"
      )
    end

    private

    def content
      @content ||= t('feed_message', text: t(message_key, **key_params), wiki_prefix: wiki_prefix, emoji: emoji)
    end
  end
end
