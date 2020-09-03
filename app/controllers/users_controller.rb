class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_eq_current_user?

  def show
  end

  private

  def user_eq_current_user?
    @user = User.find(params[:id])
    redirect_to root_path unless @user.id == current_user.id
  end
end
