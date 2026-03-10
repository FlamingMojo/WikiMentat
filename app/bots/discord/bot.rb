module Discord
  # Cheeky shortcut to use Discord.bot rather than Discord::Bot.bot.
  # It's a singleton anyway, and has to be.
  def self.bot
    Bot.bot
  end

  def self.setup
    Bot.setup
  end

  def self.run(*args)
    Bot.run(*args)
  end

  # Yes this is a ridiculous number of params, but hey it's Discord
  def self.send_message(
    channel:, content:, tts: false, embeds: nil, attachments: nil, allowed_mentions: nil, message_reference: nil,
    components: nil, flags: 0, nonce: nil, enforce_nonce: false
  )
    Bot.send_message(
      channel, content, tts, embeds, attachments, allowed_mentions, message_reference, components, flags, nonce,
      enforce_nonce
    )
  end

  def self.update_message(channel:, message:, content:, mentions: nil, embeds: nil, components: nil, flags: nil)
    ::Discordrb::API::Channel.edit_message(Bot.token, channel, message, content, mentions, embeds, components, flags)
  end

  def self.delete_message(channel:, message:, reason: nil)
    ::Discordrb::API::Channel.delete_message(Bot.token, channel, message, reason)
  end

  def self.pm_channel(*args, **kwargs)
    Bot.pm_channel(*args, **kwargs)
  end

  module Bot
    # Wrap the Discordrb::Bot in a module
    def self.run(*args)
      bot.run(*args)
    end

    # Note - calling Bot.new does initialize the bot (goes calling off to Discord)
    def self.bot
      @bot ||= Discordrb::Bot.new(token:, client_id:, log_mode:)
    end

    def self.slash_command(*args, **kwargs, &block)
      bot.register_application_command(*args, **kwargs, &block)
    end

    def self.client_id
      @client_id ||= ENV['DISCORD_CLIENT_ID']
    end

    def self.token
      @token ||= bot.token
    end

    def self.send_message(*args)
      bot.send_message(*args)
    end

    def get_user(user_id)
      bot.user(user_id)
    end

    def pm_channel(user_id)
      get_user(user_id).pm
    end

    def self.log_mode
      ENV['BOT_ENV'] == 'production' ? :normal : :debug
    end

    def self.setup
      command_modules.each(&:setup)
    end

    # This filters all sub-modules to find ones setting up discord application commands
    def self.command_modules
      modules.select do |constant|
        constant.singleton_class.included_modules.include?(::Discord::CommandHandler)
      end
    end

    def self.modules
      ::Discord::Commands.constants.map { |sym| self.const_get("::Discord::Commands::#{sym}") }
    end
  end
end
