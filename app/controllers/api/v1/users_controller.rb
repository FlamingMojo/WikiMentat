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
  end
end
