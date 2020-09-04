class CardsController < ApplicationController
  before_action :authenticate_user!
  before_action :card_is_registered?, only: [:index, :create]
  before_action :card_user_eq_current_user?, only: [:edit, :update]

  def index
    @card = Card.new
  end

  def create
    if params[:card_token] != nil
      customer_create
      @card = Card.new(card_params)
    else
      @card = Card.new(user_id: current_user.id)
    end
    if @card.save
      redirect_to root_path
    else
      render "index"
    end
  end

  def edit
  end

  def update
    if @card.update(card_token: params[:card_token])
      customer_update
      redirect_to edit_user_registration_path
    else
      render :edit
    end
  end

  private

  def customer_create
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    @customer = Payjp::Customer.create(
      description: "test",
      card: params[:card_token]
    )
  end

  def customer_update
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    card = current_user.card
    @customer = Payjp::Customer.retrieve(card.customer_token)
    old_card = @customer.cards.first
    old_card.delete
    @customer.cards.create(card: params[:card_token])
  end

  def card_params
    params.permit(:card_token).merge(customer_token: @customer.id).merge(user_id: current_user.id)
  end

  def card_is_registered?
    redirect_to edit_user_registration_path if current_user.card.present?
  end

  def card_user_eq_current_user?
    @card = Card.find(params[:id])
    redirect_to root_path unless @card.user.id == current_user.id
  end
end
