class SnsCredentialsController < ApplicationController
  def destroy
    @sns = SnsCredential.find(params[:id])
    if @sns.destroy
      redirect_to edit_user_registration_path
    else
      render 'users/registrations/edit'
    end
  end
end
