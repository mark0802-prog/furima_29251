require 'rails_helper'

RSpec.describe OrderAddress, type: :model do
  describe '商品購入機能' do
    before do
      @order_address = FactoryBot.build(:order_address)
    end

    it '全ての値が正しく入力されていれば保存できること' do
      expect(@order_address).to be_valid
    end
    it 'クレジットカード情報は必須であり、正しいクレジットカードの情報でないときは決済できないこと' do
      @order_address.token = nil
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include("Token can't be blank")
    end
    it '郵便番号が必須であること' do
      @order_address.postal_code = nil
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include("Postal code can't be blank")
    end
    it '郵便番号にはハイフンが必須であること' do
      @order_address.postal_code = '1234567'
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('Postal code is invalid. Input correctly.')
    end
    it '都道府県が必須であること' do
      @order_address.prefecture_id = 1
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('Prefecture must be selected.')
    end
    it '市区町村が必須であること' do
      @order_address.city = nil
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include("City can't be blank")
    end
    it '番地が必須であること' do
      @order_address.addresses = nil
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include("Addresses can't be blank")
    end
    it '建物名は空でも保存できること' do
      @order_address.building = nil
      @order_address.valid?
      expect(@order_address).to be_valid
    end
    it '電話番号が必須であること' do
      @order_address.phone_number = nil
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include("Phone number can't be blank")
    end
    it '電話番号にはハイフンは不要で11桁以内であること' do
      @order_address.phone_number = '123-4567-89'
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('Phone number is invalid. Input half-width numbers correctly.')
    end
    it '電話番号は10桁以上であること' do
      @order_address.phone_number = '123456789'
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('Phone number is invalid. Input half-width numbers correctly.')
      @order_address.phone_number = '1234567890'
      expect(@order_address).to be_valid
    end
  end
end
