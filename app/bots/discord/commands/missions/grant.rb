# frozen_string_literal: true

# Invoked from selecting mission type from Init
# Returns a new modal to create mission
module Discord::Commands::Missions
  class Grant
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.grant'

    def content
      return t('not_enabled') unless guild_config.enable_missions
      return t('not_found') unless assignee

      count.times do
        create_mission
      end

      t('granted', count:, user_id:)
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    private

    def count
      event.options['count'].to_i
    end

    def create_mission
      mission = Mission.create!(
        type: :page_create,
        status: :submitted,
        guild_config:,
        issuer: mentat_member,
        assignee:,
        manually_granted: true,
        title:,
        description: event.options['description']
      )
      mission.approve
    end

    def title
      @title ||= "Mission Credit for <@#{assignee.discord_uid}> (@#{assignee.username})"
    end

    def assignee
      @assignee ||= guild.find_member_by_discord_uid(user_id)
    end

    def user_id
      event.options['target_user'].to_s
    end

    def wiki
      @wiki ||= guild_config.wiki
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
