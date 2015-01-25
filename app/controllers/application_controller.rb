class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :require_admin!

  def require_admin!
    # FIXME: be more graceful
    if current_user && !current_user.admin?
      raise "#{current_user} is not an admin!"
    end
  end

  def octoclient
    if token = current_user.github_access_token
      @_octoclient = Octokit::Client.new access_token: token
    else
      session[:add_github_access_token_return] = request.path
      redirect_to user_access_token_path, danger: 'You must provide a Github access token'
    end
  end
end
