FactoryBot.define do
  factory :order_address do
    token { Faker::Internet.password }
    postal_code { '123-4567' }
    prefecture_id { Faker::Number.between(from: 2, to: 48) }
    city { Faker::Address.city }
    addresses { Faker::Address.street_address }
    building { Faker::Address.building_number }
    phone_number { Faker::Number.number(digits: 11) }
  end
end
