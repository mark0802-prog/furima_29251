class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         with_options presence: true do
           validates :nickname
           validates :first_name, format: {with: /\A[ぁ-んァ-ン一-龥]/, message: "is invalid. Input full-width characters."}
           validates :last_name, format: {with: /\A[ぁ-んァ-ン一-龥]/, message: "is invalid. Input full-width characters."}
           validates :first_name_kana, format: {with: /\A[ァ-ヶー－]+\z/, message: "is invalid. Input full-width katakana characters."}
           validates :last_name_kana, format: {with: /\A[ァ-ヶー－]+\z/, message: "is invalid. Input full-width katakana characters."}
           validates :birth_date
         end

         validates :password, format: {with: /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i, message: "is invalid. Input half-width alphanumeric mixture."}
end
