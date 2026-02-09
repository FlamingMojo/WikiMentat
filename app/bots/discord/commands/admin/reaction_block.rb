# frozen_string_literal: true

module Discord::Commands::Admin
  class ReactionBlock
    extend Forwardable
    include ::Discord::Util

    def_delegators :event, :user, :message
    def_delegators :message, :author
    def_delegators :mentat_message, :webhook
    def_delegators :webhook, :registered_user?, :created_page?, :wiki

    def handle
      return unless author.id == ENV['DISCORD_CLIENT_ID'].to_i
      return unless mentat_member.moderator? || mentat_member.admin?
      return unless mentat_message && webhook && wiki_bot
      return unless registered_user? || created_page?

      if registered_user?
        block_user!
      else
        delete_page!
        block_user!
      end
    rescue => error
      DiscordError.handle(error:, user: User.new(discord_uid: event.user.id), service: self.class.to_s)
    end

    def block_user!
      wiki_bot.block_user(user: webhook.user.name, reason: t('admin.reaction_block.reason', admin: user.global_name))
    end

    def delete_page!
      wiki_bot.delete_page(webhook.page.name, t('admin.reaction_block.reason', admin: user.global_name))
    end

    def mentat_message
      @mentat_message ||= Message.find_by(discord_uid: message.id)
    end

    def wiki_bot
      @wiki_bot ||= WikiBot.find_by(guild: guild, wiki: wiki)
    end
  end
end
