# frozen_string_literal: true

module Discord::Commands::Missions
  class Leaderboard::Embed
    include ::Translatable

    with_locale_context 'discord.commands.missions.leaderboard.embed'

    attr_reader :guild_config

    def initialize(guild_config)
      @guild_config = guild_config
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
      leaders.first(10).each do |leader|
        embed.add_field(name: t("places.#{leader[:place]}"), value: leader[:label])
      end

      embed
    end

    private

    def embed
      @embed ||= Discordrb::Webhooks::Embed.new
    end

    def leaders
      top_ten_scores.each_with_index.flat_map do |score, place|
        leader_ids = top_ten.select { |_k, v| v == score }.keys

        leader_ids.map do |leader_id|
          { place:, label: "@#{Member.find(leader_id).username} - **#{score}**" }
        end
      end
    end

    def top_ten
      completed_counts.select { |_k, score| top_ten_scores.include?(score) }
    end

    def top_ten_scores
      completed_counts.values.uniq.max(10).sort.reverse
    end

    def completed_counts
      @completed_counts ||= guild_config.missions.completed.where.not(assignee_id: nil).group(:assignee_id).count
    end
  end
end
