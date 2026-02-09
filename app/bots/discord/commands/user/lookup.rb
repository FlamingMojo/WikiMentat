module Discord::Commands::User
  class Lookup
    include ::Discord::Util

    def content
      return t('user.lookup.not_found') unless wiki_users.any?

      t('user.lookup.found', user_id: user_id, wiki_usernames: wiki_users.map(&:username).join(', '))
    end

    def response_method
      :update_message
    end

    private

    def wiki_users
      return [] unless target_user

      @wiki_users ||= target_user.wiki_users.where(wiki_id: wiki_id)
    end

    def target_user
      @target_user ||= User.find_by(discord_uid: user_id)
    end

    def wiki_id
      custom_id.split(':').last
    end

    def user_id
      event.values.first.id || user.id
    end
  end
end
