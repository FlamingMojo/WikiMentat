class DiscordError
  include ::Translatable

  with_locale_context 'discord.commands'

  attr_reader :error, :service
  private :error, :service

  EXCLUDE_MESSAGES = ['Unknown interaction'].freeze

  def initialise(error, service: '', user: '')
    @error = error
    @service = service
    @user = user
  end

  def self.handle(error, service: '', user: '')
    new(error, service:, user:).handle
  end

  def handle
    return if EXCLUDE_MESSAGES.include?(message.strip)

    Discord.send_message(channel: ENV['ERROR_LOG_CHANNEL'], content:, allowed_mentions: {})
    t('something_went_wrong')
  end

  private

  def content
    t('dev_error', user:, service:, message:, backtrace:)
  end

  def user
    return @user unless @user.respond_to?(:discord_uid)

    "<@#{@user.discord_uid}>"
  end

  def message
    error.message.truncate(100)
  end

  def backtrace
    error.backtrace.join("\n").truncate(1000)
  end
end
