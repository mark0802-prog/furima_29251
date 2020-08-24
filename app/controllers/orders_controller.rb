class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :item_user_noteq_current_user?

  def index
    @order = Order.new
  end

  def create
  end

  private

  def item_user_noteq_current_user?
    @item = Item.find(params[:item_id])
    redirect_to root_path if @item.user.id == current_user.id
  end
end
