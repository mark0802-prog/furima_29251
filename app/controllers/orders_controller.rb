class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :item_user_noteq_current_user?
  before_action :item_is_sold_out?

  def index
    @order = OrderAddress.new
  end

  def create
    @order = OrderAddress.new(order_params)
    if @order.valid?
      pay_item(@item)
      @order.save
      redirect_to root_path
    else
      render :index
    end
  end

  private

  def order_params
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city,
                                          :addresses, :building, :phone_number)
          .merge(user_id: current_user.id).merge(token: params[:token]).merge(item_id: params[:item_id])
  end

  def pay_item(item)
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: item.price,
      card: order_params[:token],
      currency: 'jpy'
    )
  end

  def item_user_noteq_current_user?
    @item = Item.find(params[:item_id])
    redirect_to root_path if @item.user.id == current_user.id
  end

  def item_is_sold_out?
    redirect_to root_path unless @item.order.nil?
  end
end
