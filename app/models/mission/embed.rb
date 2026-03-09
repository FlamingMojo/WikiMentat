# frozen_string_literal: true

class Mission
  class Embed
    include Translatable

    with_locale_context 'mission.embed'

    attr_reader :mission

    def initialize(mission)
      @mission = mission
    end

    def self.generate(mission)
      new(mission).generate
    end

    def generate
      embed.title = mission.summary
      embed.colour = mission.colour
      embed.description = mission.description
      embed.timestamp = Time.now
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: mission.thumbnail)
      embed.add_field(name: t('field.instructions'), value: mission.instructions, inline: true)
      embed.add_field(name: t('field.status'), value: mission.status.titleize, inline: true)
      embed.add_field(name: t('field.issuer'), value: "<@#{mission.issuer.discord_uid}>", inline: true)
      embed.add_field(name: t('field.wiki_page'), value: mission.wiki_page_md, inline: true) if mission.wiki_page?
      embed.add_field(name: t('field.map_link'), value: mission.map_link_md, inline: true) if mission.map_link?
      embed.add_field(name: t('field.language'), value: mission.language, inline: true) if mission.language?
      embed.add_field(name: t('field.rule'), value: mission.image_rule.name, inline: true) if mission.image_rule
      embed.add_field(name: t('field.assignee'), value: assignee)

      embed
    end

    def assignee
      return t('no_assignee') unless mission.assignee

      "<@#{mission.assignee.discord_uid}>"
    end

    def embed
      @embed ||= Discordrb::Webhooks::Embed.new
    end
  end
end
