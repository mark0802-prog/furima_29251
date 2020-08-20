FactoryBot.define do
  factory :user do
    nickname {Faker::Internet.username}
    email {Faker::Internet.email}
    password {Faker::Internet.password(min_length: 8, mix_case: true)}
    password_confirmation {password}
    first_name {"田中"}
    last_name {"一郎"}
    first_name_kana {"タナカ"}
    last_name_kana {"イチロウ"}
    birth_date {Faker::Date.between(from: '1930-01-01', to: '2015-12-31')}
  end
end
