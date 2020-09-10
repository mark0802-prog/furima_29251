class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    user_sns = User.from_omniauth(request.env["omniauth.auth"])
    @user = user_sns[:user]
    @sns_id = user_sns[:sns].id

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      render "users/registrations/new"
    end
  end

  def failure
    redirect_to root_path
  end
end
