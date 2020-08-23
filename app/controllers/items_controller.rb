class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @items = Item.includes(:order, image_attachment: :blob)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :info, :category_id,
                                 :sales_status_id, :shipping_fee_status_id, :prefecture_id,
                                 :scheduled_delivery_id, :price, :image)
          .merge(user_id: current_user.id)
  end
end
