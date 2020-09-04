class OrderAddress
  include ActiveModel::Model
  attr_accessor :token, :user_id, :item_id, :postal_code, :prefecture_id, :city, :addresses, :building, :phone_number

  postal_code = /\A\d{3}[-]\d{4}\z/
  phone_number = /\A\d{10,11}\z/

  with_options presence: true do
    validates :postal_code, format: { with: postal_code, message: 'はハイフン（-）ありの半角数字で入力してください' }
    validates :prefecture_id, numericality: { other_than: 1, message: 'を選択してください' }
    validates :city
    validates :addresses
    validates :phone_number, format: { with: phone_number, message: 'はハイフン（-）なしの半角数字10桁または11桁で入力してください' }
  end

  def save
    order = Order.create(user_id: user_id, item_id: item_id)
    Address.create(postal_code: postal_code, prefecture_id: prefecture_id, city: city,
                   addresses: addresses, building: building, phone_number: phone_number, order_id: order.id)
  end
end
