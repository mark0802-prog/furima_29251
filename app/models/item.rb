class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash [:category, :sales_status, :shipping_fee_status, :prefecture, :scheduled_delivery] 

  belongs_to :user
  has_one_attached :image
end
