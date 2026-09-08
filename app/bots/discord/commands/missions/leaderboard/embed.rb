# frozen_string_literal: true

module Discord::Commands::Missions
  class Leaderboard::Embed
    include ::Translatable

    with_locale_context 'discord.commands.missions.leaderboard.embed'

    attr_reader :guild_config

    def initialize(guild_config)
      @guild = guild_config
    end

    def self.generate(guild_config)
      new(guild_config).generate
    end

    def generate
      embed.title = t('title')
      embed.description = t('description')
      embed.colour = 0x81D41A
      embed.timestamp = Time.now
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: Discord::Bot.avatar_url)
      leaders.each_with_index do |leader, index|
        embed.add_field(name: t("places.#{index}"), value: leader)
      end

      embed
    end

    private

    def embed
      @embed ||= Discordrb::Webhooks::Embed.new
    end

    def leaders
      place = 0
      top_ten.map do |member_id, score|
        next if place >= 10

        place += 1
        "<@#{Member.find(member_id).discord_uid}> - **#{score}**"
      end.compact
    end

    def top_ten
      completed_counts.select { |_k, score| top_ten_scores.include?(score) }
    end

    def top_ten_scores
      completed_counts.values.max(10)
    end

    def completed_counts
      @completed_counts ||= guild_config.missions.completed.where.not(assignee_id: nil).group(:assignee_id).count
    end
  end
end
