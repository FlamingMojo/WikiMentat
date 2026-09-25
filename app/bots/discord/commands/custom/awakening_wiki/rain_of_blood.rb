# frozen_string_literal: true

module Discord::Commands::Custom::AwakeningWiki
  class RainOfBlood
    extend Forwardable
    include ::Discord::Util
    include ::Translatable

    with_locale_context 'discord.commands.user.upload_image'

    TRIGGER_WORDS = [
      'rain of blood', 'sayldam', 'blood rain', 'rain blood', 'npc killed', 'npcs killed', 'blood event', 'challenge'
    ]

    def_delegators :message, :attachments
    def_delegators :event, :message, :text

    def handle
      return unless TRIGGER_WORDS.any? { |w| message_text.downcase.include?(w) }
      event.respond(content)
    end

    private

    def content
      total = 'countless'

      if api_response.success?
        total = JSON.parse(api_response.body)['total'] || total
      end

      "The blood of #{total} bodies have been spilled during El Sayldam so far..."
    rescue => e
      t('error', user_id: user.id, error: e.message.truncate(500))
    end

    def api_response
      @api_response ||= Faraday.get('https://funcom.nyc3.digitaloceanspaces.com/bucket/DA/challenge/latest.json')
    end

    def message_text
      text.gsub("<@#{Discord::Bot.client_id}>", '').strip
    end
  end
end
