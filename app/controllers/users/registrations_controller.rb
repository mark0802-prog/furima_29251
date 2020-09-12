# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    if (@sns_id = params[:sns_auth])
      pass = "#{Devise.friendly_token[0, 20]}0"
      pass = "#{Devise.friendly_token[0, 20]}0" while pass.count('-_').positive?
      params[:user][:password] = pass
      params[:user][:password_confirmation] = pass
    end
    super
    return unless @sns_id && @user.valid?

    sns = UserSns.new(sns_id: @sns_id, user_id: @user.id)
    sns.update
  end

  # GET /resource/edit
  def edit
    @sns_facebook = SnsCredential.find_by(user_id: current_user.id, provider: 'facebook')
    @sns_google = SnsCredential.find_by(user_id: current_user.id, provider: 'google_oauth2')
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    return unless current_user.card.present?

    customer = Payjp::Customer.retrieve(current_user.card.customer_token)
    @card = customer.cards.first
    @card_id = current_user.card.id
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
