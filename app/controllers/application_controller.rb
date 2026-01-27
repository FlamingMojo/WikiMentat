class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_back(fallback_location: root_path, alert: 'You are not authorized to perform this action.')
  end

  def ensure_login
    redirect_to root_path unless session_user
  end

  def session_user
    @session_user ||= User.find_by(id: session[:user_id])
  end
  alias_method :pundit_user, :session_user
end
