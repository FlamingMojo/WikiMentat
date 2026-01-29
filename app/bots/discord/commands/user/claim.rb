module Discord::Commands::User
  class Claim
    include ::Discord::Util

    def content
      return claimed_message if already_claimed?

      claim = mentat_user.user_claims.find_or_create_by!(wiki:, claimed_username: wiki_username)
      t('user.claim.instructions', wiki_username: wiki_username, claim_code: claim.claim_code, wiki_url: wiki.url)
    end

    private

    def claimed_message
      if owning_user == mentat_user
        t('user.claim.already_verified', wiki_username: wiki_username)
      else
        t('user.claim.already_claimed', wiki_username: wiki_username, owner_id: owning_user.discord_uid)
      end
    end

    def already_claimed?
      return false unless wiki_user

      owning_user.present?
    end

    def owning_user
      @owning_user ||= wiki_user.user
    end

    def wiki
      @wiki ||= Wiki.find_by(id: wiki_id)
    end

    def wiki_user
      @wiki_user ||= WikiUser.find_by(username: wiki_username)
    end

    def wiki_username
      modal_values['wiki_username']
    end

    def modal_keys
      %w[wiki_username]
    end

    def wiki_id
      custom_id.split(':').last
    end
  end
end
