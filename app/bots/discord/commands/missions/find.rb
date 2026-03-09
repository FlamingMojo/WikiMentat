# frozen_string_literal: true

module Discord::Commands::Missions
  class Find
    include Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.find'

    def content
      return t('../not_enabled') unless guild_config.enable_missions
      return t('not_found') unless target_member
      return other_user_mission if other_user?

      self_mission
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    private

    def other_user_mission
      if current_mission
        t('found', user_id: target_member.discord_uid, **mission_attributes)
      else
        t('no_mission', user_id: target_member.discord_uid)
      end
    end

    def self_mission
      if current_mission
        t('found_self', **mission_attributes)
      else
        t('no_mission_self')
      end
    end

    def mission_attributes
      { summary: current_mission.summary, link: current_mission.discord_post_link }
    end

    def current_mission
      @current_mission ||= target_member.current_mission
    end

    def target_member
      @target_member ||= find_member
    end

    def find_member
      return mentat_member unless other_user?

      guild.find_member_by_discord_uid(user_id)
    end

    def other_user?
      !!event.options['target_user']
    end

    def user_id
      event.options['target_user'].to_s
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
