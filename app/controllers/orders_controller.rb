class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :item_user_noteq_current_user?
  before_action :item_is_sold_out?
  before_action :card_is_registered?

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
          .merge(user_id: current_user.id).merge(item_id: params[:item_id])
  end

  def pay_item(item)
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    customer_token = current_user.card.customer_token
    Payjp::Charge.create(
      amount: item.price,
      customer: customer_token,
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

  def card_is_registered?
    redirect_to cards_path and return unless current_user.card.present?
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    card = Card.find_by(user_id: current_user.id)
    customer = Payjp::Customer.retrieve(card.customer_token)
    @card = customer.cards.first
  end
end
