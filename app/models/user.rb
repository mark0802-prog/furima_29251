class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :orders

  zennkaku = /\A[ぁ-んァ-ン一-龥]/
  zennkaku_katakana = /\A[ァ-ヶー－]+\z/
  alphanumeric_mixture = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i

  with_options presence: true do
    validates :nickname
    validates :first_name, format: { with: zennkaku, message: 'は全角で入力してください' }
    validates :last_name, format: { with: zennkaku, message: 'は全角で入力してください' }
    validates :first_name_kana, format: { with: zennkaku_katakana, message: 'は全角カタカナで入力してください' }
    validates :last_name_kana, format: { with: zennkaku_katakana, message: 'は全角カタカナで入力してください' }
    validates :birth_date
  end

  validates :password, format: { with: alphanumeric_mixture,
                                 message: 'は半角英数字混合で入力してください' }, allow_blank: true
end
