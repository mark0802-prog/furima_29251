class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :category
  belongs_to_active_hash :sales_status
  belongs_to_active_hash :shipping_fee_status
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :scheduled_delivery

  belongs_to :user
  has_one_attached :image

  half_width_number = /\A[0-9]+\z/

  with_options presence: true do
    validates :image
    validates :name
    validates :info
    validates :price, format: {with: half_width_number, message: 'is invalid. Input half-width number.'},
    numericality: {greater_than_or_equal_to: 300, less_than_or_equal_to:9999999, message: 'is out of setting range.'}
  end
  with_options numericality: {other_than: 1, message: 'must be selected.'} do
    validates :category_id
    validates :sales_status_id
    validates :shipping_fee_status_id
    validates :prefecture_id
    validates :scheduled_delivery_id
  end
end
