module API::V1
  class UsersController < APIController
    def show
      @user = User.find_by(discord_uid: params[:id])

      if @user
        handle_response(@user.to_json)
      else
        handle_response({ error: 'User not found.' }, status: 404)
      end
    end

    def verify_wiki_user
      if claimable?
        user_claim.complete_with(wiki_user)
        handle_response({ message: "Successfully linked #{wiki_user.user.username} to your Wiki account" }, status: 200)
      else
        handle_response({ error: "Unable to verify - #{@error}" }, status: 200)
      end
    end

    private

    def claimable?
      @error = 'Internal Error, contact [[User:FlamingMojo|Mojo]]' and return false unless wiki
      @error = 'Claim code not found' and return false unless claim_code
      @error = 'Your user cannot be found, contact [[User:FlamingMojo|Mojo]]' and return false unless wiki_user
      @error = 'User Claim not found for that code' and return false unless user_claim

      true
    end

    def user_claim
      @user_claim = UserClaim.pending.find_by(wiki:, claimed_username: wiki_user.username, claim_code:)
    end

    def claim_code
      params[:claim_code]
    end

    def wiki_user
      @wiki_user ||= wiki.wiki_users.find_by(username: params[:username])
    end

    def wiki
      @wiki ||= Wiki.find_by(id: params[:wiki_id])
    end
  end
end
