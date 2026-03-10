# frozen_string_literal: true

# Invoked from button on reward issued in high council channel after 7 missions.
module Discord::Commands::Missions
  class Reward::Confirm
    include ::Translatable
    include ::Discord::Util

    with_locale_context 'discord.commands.missions.reward'

    def content
      return t('not_found') unless member_reward
      return already_claimed if user_already_rewarded?

      member_reward.award(mentat_member)
      Discord.send_message(channel: notifications_channel.discord_uid, content: t('broadcast', user_id:, reward:))
      Discord.send_message(channel: admin_channel.discord_uid, content: t('approved', user_id:, key:, reward:))
      delete_message

      t('approved', user_id:, key:, reward:)
    end

    def ephemeral
      false
    end

    private

    def delete_message
      Discord.delete_message(channel: event.message.channel.id, message: event.message.id)
    end

    def already_claimed
      member_reward.unclaim!
      delete_message
      t('already_claimed')
    end

    def user_already_rewarded?
      rewarded_member.claimed_rewards.include?(member_reward.reward_key)
    end

    def key
      @key ||= member_reward.redacted
    end

    def user_id
      @user_id ||= rewarded_member.discord_uid
    end

    def reward
      @reward ||= member_reward.reward_type.name
    end

    def rewarded_member
      @rewarded_member ||= member_reward.member
    end

    def member_reward
      @member_reward ||= MemberReward.find_by(id: custom_id.split(':').last)
    end

    def admin_channel
      @admin_channel ||= guild_config.mission_admin_channel
    end

    def notifications_channel
      @notifications_channel ||= guild_config.mission_notifications_channel
    end

    def guild_config
      @guild_config ||= guild.primary_config
    end
  end
end
