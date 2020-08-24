class OrderAddress
  include ActiveModel::Model
  attr_accessor :token, :user_id, :item_id, :postal_code, :prefecture_id, :city, :addresses, :building, :phone_number

  postal_code = /\A\d{3}[-]\d{4}\z/

  with_options presence: true do
    validates :token
    validates :postal_code, format: { with: postal_code, message: 'is invalid. Input correctly.' }
    validates :prefecture_id, numericality: { other_than: 1, message: 'must be selected.' }
    validates :city
    validates :addresses
    validates :phone_number, numericality: { message: 'is invalid. Input half-width numbers.' }
  end

  def save
    order = Order.create(user_id: user_id, item_id: item_id)
    Address.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city,
                   addresses: addresses, building: building, phone_number: phone_number, order_id: order.id)
  end
end
