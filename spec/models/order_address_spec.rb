require 'rails_helper'

RSpec.describe OrderAddress, type: :model do
  describe '商品購入機能' do
    before do
      @order_address = FactoryBot.build(:order_address)
    end

    it '全ての値が正しく入力されていれば保存できること' do
      expect(@order_address).to be_valid
    end
    it '郵便番号が必須であること' do
      @order_address.postal_code = nil
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('郵便番号を入力してください')
    end
    it '郵便番号にはハイフンが必須であること' do
      @order_address.postal_code = '1234567'
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('郵便番号はハイフン（-）ありの半角数字で入力してください')
    end
    it '都道府県が必須であること' do
      @order_address.prefecture_id = 1
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('都道府県を選択してください')
    end
    it '市区町村が必須であること' do
      @order_address.city = nil
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('市区町村を入力してください')
    end
    it '番地が必須であること' do
      @order_address.addresses = nil
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('番地を入力してください')
    end
    it '建物名は空でも保存できること' do
      @order_address.building = nil
      @order_address.valid?
      expect(@order_address).to be_valid
    end
    it '電話番号が必須であること' do
      @order_address.phone_number = nil
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('電話番号を入力してください')
    end
    it '電話番号にはハイフンは不要で11桁以内であること' do
      @order_address.phone_number = '123-4567-89'
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('電話番号はハイフン（-）なしの半角数字10桁または11桁で入力してください')
    end
    it '電話番号は10桁以上であること' do
      @order_address.phone_number = '123456789'
      @order_address.valid?
      expect(@order_address.errors.full_messages).to include('電話番号はハイフン（-）なしの半角数字10桁または11桁で入力してください')
      @order_address.phone_number = '1234567890'
      expect(@order_address).to be_valid
    end
  end
end
