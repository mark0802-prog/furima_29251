class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :item_user_noteq_current_user?

  def index
    @order = OrderAddress.new
  end

  def create
    @order = OrderAddress.new(order_params)
    if @order.save
      redirect_to root_path
    else
      render :index
    end
  end

  private

  def order_params
    params.require(:order).permit(:postal_code, :prefecture_id, :city, :ddresses, :building, :phone_number).merge(user_id: current_user.id, item_id: @item.id)
  end

  def item_user_noteq_current_user?
    @item = Item.find(params[:item_id])
    redirect_to root_path if @item.user.id == current_user.id
  end
end
