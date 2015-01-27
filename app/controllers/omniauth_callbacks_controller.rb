class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    info = request.env["omniauth.auth"]["info"]
    user = User.where(github_username: info["nickname"]).first_or_create! do |u|
      u.email = info["email"]
      u.name  = info["name"]
    end

    sign_in_and_redirect user, event: :authentication
    set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
  end
end
