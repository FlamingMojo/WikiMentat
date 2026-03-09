# frozen_string_literal: true

module Discord::Commands::Missions
  class Count
    include Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.count'

    def content
      return t('../not_enabled') unless guild_config.enable_missions
      return t('not_found') unless target_member

      if other_user?
        t('found', user_id: target_member.discord_uid, count: missions_count)
      else
        t('found_self', count: missions_count)
      end
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    private

    def missions_count
      @missions_count ||= target_member.missions.completed.count
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
