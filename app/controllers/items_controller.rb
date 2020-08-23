class ItemsController < ApplicationController
  def index
    @items = Item.includes(:order, image_attachment: :blob)
  end

  def new
    authenticate_user!
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      @item.valid?
      render :new
    end
  end

  def show
  end

  private

  def item_params
    params.require(:item).permit(:name, :info, :category_id,
                                 :sales_status_id, :shipping_fee_status_id, :prefecture_id,
                                 :scheduled_delivery_id, :price, :image)
          .merge(user_id: current_user.id)
  end
end
