# frozen_string_literal: true

module Discord::Commands::Custom::AwakeningWiki
  class RainOfBlood
    extend Forwardable
    include ::Discord::Util
    include ::Translatable

    with_locale_context 'discord.commands.user.upload_image'

    TAMZIN_ID = '1476239415532584981'
    TAMZIN_HELLO = "Good day Tamzin, how is employment under the Archivist's Guild?"
    TAMZIN_NEUTRAL = "I'm sorry, I don't quite understand."
    TAMZIN_ANGRY = "Dude what the fuck it's hot as hell on the sands and you're bugging me like some fuckass tax collector - shoo!"
    TRIGGER_WORDS = [
      'rain of blood', 'sayldam', 'blood rain', 'rain blood', 'npc killed', 'npcs killed', 'blood event', 'challenge'
    ]

    def_delegators :message, :attachments
    def_delegators :event, :message, :text

    def handle
      return unless content
      event.respond(content)
    end

    private

    def content
      return blood_response if TRIGGER_WORDS.any? { |w| message_text.downcase.include?(w) }
      return tamzin_response if user.id.to_s == TAMZIN_ID

      "Yes yes I'm awake."
    rescue => e
      t('error', user_id: user.id, error: e.message.truncate(500))
    end

    def tamzin_response
      return TAMZIN_HELLO if message_text.downcase.start_with?('greetings,')
      return TAMZIN_ANGRY if rand <= 0.1 # 10% chance to get angry

      TAMZIN_NEUTRAL
    end

    def blood_response
      total = 'countless'

      if api_response.success?
        total = JSON.parse(api_response.body)['total'] || total
      end

      "The blood of #{total} bodies have been spilled during El Sayldam so far..."
    end

    def api_response
      @api_response ||= Faraday.get('https://funcom.nyc3.digitaloceanspaces.com/bucket/DA/challenge/latest.json')
    end

    def message_text
      text.gsub("<@#{Discord::Bot.client_id}>", '').strip
    end
  end
end
