# frozen_string_literal: true

module Discord::Commands::Missions
  class Rewards
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.rewards'

    def content
      return t('not_enabled') unless guild_config.enable_rewards
      return t('no_rewards') unless member_reward.any?

      t('message', rewards: member_reward.map(&:to_message).join("\n- "))
    rescue => error
      DiscordError.handle(error:, user: mentat_user, service: self.class.to_s)
    end

    private

    def member_reward
      @member_reward ||= mentat_member.member_rewards.approved
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
