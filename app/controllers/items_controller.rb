class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :item_user_eq_current_user?, only: [:edit, :update, :destroy]

  def index
    @items = Item.includes(:order).with_attached_images
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
    @item = Item.with_attached_images.find(params[:id])
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to root_path
    else
      render :show
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :info, :category_id,
                                 :sales_status_id, :shipping_fee_status_id, :prefecture_id,
                                 :scheduled_delivery_id, :price, images: [])
          .merge(user_id: current_user.id)
  end

  def item_user_eq_current_user?
    @item = Item.with_attached_images.find(params[:id])
    redirect_to root_path unless @item.user.id == current_user.id
  end
end
