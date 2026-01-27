class SessionsController < ActionController::Base
  skip_before_action :verify_authenticity_token, only: %i[create]
  def new
    render :new
  end

  def create
    user = User.login_with_oauth(request.env['omniauth.auth'])

    if user
      session[:user_id] = user.id

      redirect_to admin_root_path
    else
      redirect_to root_path
    end
  end

  def destroy
    session.delete(:user_id)

    redirect_to root_path
  end
end
