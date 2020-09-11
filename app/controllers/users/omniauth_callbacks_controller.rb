class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorization, except: :failure

  def facebook
  end

  def google_oauth2
  end

  def failure
    redirect_to root_path
  end

  private

  def authorization
    if user_signed_in?
      sns = User.linked_sns(request.env["omniauth.auth"])
      sns.update(user_id: current_user.id)
      redirect_to edit_user_registration_path and return
    end

    user_sns = User.from_omniauth(request.env["omniauth.auth"])
    @user = user_sns[:user]
    @sns_id = user_sns[:sns].id

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      render "users/registrations/new"
    end
  end
end
