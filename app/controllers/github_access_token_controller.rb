class GithubAccessTokenController < ApplicationController
  skip_before_filter :require_access_token!

  def edit
  end

  def update
    current_user.update_attribute :github_access_token, params[:access_token]
    back = session.delete(:add_github_access_token_return) || teams_path
    redirect_to back
  end
end
