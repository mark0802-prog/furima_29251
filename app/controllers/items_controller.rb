class ItemsController < ApplicationController
  def index
  end

  def new
    authenticate_user!
  end

  def create
    @item = Item.create(item_params)
  end

  private

  def item_params
    params.require(:item).permit(:name, :info, :category, :sales_status, :shipping_fee_status, :prefecture, :scheduled_delivery, :price, :image).merge(user_id: current_user.id)
  end
end
