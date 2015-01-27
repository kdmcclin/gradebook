class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :require_access_token!

  def require_access_token!
    unless current_user.github_access_token
      session[:add_github_access_token_return] = request.path
      redirect_to user_access_token_path and return
    end
  end

  def octoclient
    current_user.octoclient
  end
end
