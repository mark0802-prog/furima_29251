class ItemsController < ApplicationController
  def index
  end

  def new
    authenticate_user!
  end

  def create
  end
end
