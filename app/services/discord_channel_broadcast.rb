class DiscordChannelBroadcast
  extend Forwardable

  attr_reader :content, :guild_config
  private :content, :guild_config

  def_delegators :guild_config, :update_feeds, :send_discord_messages?

  def initialize(guild_config:, content:)
    @guild_config = guild_config
    @content = content
  end

  def perform
    return if disabled?

    update_feeds.each do |channel|
      message = Discord.send_message(channel: channel.discord_uid, content:)
      Message.create(message_type: :broadcast, channel:, content:, discord_uid: message.id)
    end
  rescue => error
    DiscordError.handle(error:, user: 'System', service: self.class.to_s)
  end

  private

  def disabled?
    return true unless send_discord_messages? && update_feeds.any?

    false
  end
end
