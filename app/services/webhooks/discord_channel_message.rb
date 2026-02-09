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
        Discord.send_message(channel:, content: t(message_key, **key_params))
      end

    rescue => e
      short_message = e.message.truncate(1000)
      puts "⚠️[#{webhook.id}](#{ENV['HOST_URL']}/admin/webhooks/#{webhook.id}) ERROR: ```#{short_message}```"
    end
  end
end
