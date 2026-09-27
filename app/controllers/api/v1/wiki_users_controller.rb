module API::V1
  class WikiUsersController < APIController
    def show
      if wiki_user
        handle_response(wiki_user.to_json)
      else
        handle_response({ error: @error }, status: 404)
      end
    end


    private

    def wiki_user?
      @error = 'Wiki not found' and return false unless wiki
      @error = 'Wiki User not found' and return false unless wiki_user

      true
    end

    def wiki_user
      @wiki_user ||= wiki.wiki_users.find_by(username: params[:id])
    end

    def wiki
      @wiki ||= Wiki.find_by(id: params[:wiki_id])
    end
  end
end
