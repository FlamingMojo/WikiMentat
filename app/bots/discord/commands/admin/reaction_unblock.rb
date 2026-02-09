# frozen_string_literal: true

module Discord::Commands::Admin
  class ReactionUnblock
    extend Forwardable
    include ::Discord::Util

    def_delegators :event, :user, :message
    def_delegators :message, :author
    def_delegators :mentat_message, :webhook
    def_delegators :webhook,  :registered_user?, :created_page?, :wiki

    def handle
      return unless author.id == ENV['DISCORD_CLIENT_ID'].to_i
      return unless mentat_member.moderator? || mentat_member.admin?
      return unless mentat_message && webhook && wiki_bot
      return unless registered_user?

      wiki_bot.unblock_user(
        user: webhook.user.name,
        reason: t('admin.reaction_unblock.reason', admin: user.global_name)
      )
    rescue => e
      short_message = e.message.truncate(1000)
      Discord.send_message(
        channel: ENV['ERROR_LOG_CHANNEL'],
        content: "⚠️Reaction failed! `<@#{user.id}>` reacted to message [#{message.id}]. ERROR: ```#{short_message}```"
      )
    end

    def mentat_message
      @mentat_message ||= Message.find_by(discord_uid: message.id)
    end

    def wiki_bot
      @wiki_bot ||= WikiBot.find_by(guild: guild, wiki: wiki)
    end
  end
end
