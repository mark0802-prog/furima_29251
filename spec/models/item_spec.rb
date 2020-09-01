require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '商品出品機能' do
    before do
      @item = FactoryBot.build(:item)
      @item.images = [fixture_file_upload('public/images/test_image.png')]
    end

    it '全ての値が正しく入力されていれば保存できること' do
      expect(@item).to be_valid
    end
    it '画像は1枚必須であること' do
      @item.images = nil
      @item.valid?
      expect(@item.errors.full_messages).to include("Images can't be blank")
    end
    it '画像が複数枚でも保存できること' do
      @item.images = [fixture_file_upload('public/images/test_image0.png'),
                      fixture_file_upload('public/images/test_image1.png'), fixture_file_upload('public/images/test_image2.png')]
      expect(@item).to be_valid
    end
    it '商品名が必須であること' do
      @item.name = nil
      @item.valid?
      expect(@item.errors.full_messages).to include("Name can't be blank")
    end
    it '商品の説明が必須であること' do
      @item.info = nil
      @item.valid?
      expect(@item.errors.full_messages).to include("Info can't be blank")
    end
    it 'カテゴリーの情報が必須であること' do
      @item.category_id = 1
      @item.valid?
      expect(@item.errors.full_messages).to include('Category must be selected.')
    end
    it '商品の状態についての情報が必須であること' do
      @item.sales_status_id = 1
      @item.valid?
      expect(@item.errors.full_messages).to include('Sales status must be selected.')
    end
    it '配送料の負担についての情報が必須であること' do
      @item.shipping_fee_status_id = 1
      @item.valid?
      expect(@item.errors.full_messages).to include('Shipping fee status must be selected.')
    end
    it '配送元の地域についての情報が必須であること' do
      @item.prefecture_id = 1
      @item.valid?
      expect(@item.errors.full_messages).to include('Prefecture must be selected.')
    end
    it '発送までの日数についての情報が必須であること' do
      @item.scheduled_delivery_id = 1
      @item.valid?
      expect(@item.errors.full_messages).to include('Scheduled delivery must be selected.')
    end
    it '価格についての情報が必須であること' do
      @item.price = nil
      @item.valid?
      expect(@item.errors.full_messages).to include("Price can't be blank")
    end
    it '価格が300円以上であること' do
      @item.price = 299
      @item.valid?
      expect(@item.errors.full_messages).to include('Price is out of setting range.')
      @item.price = 300
      expect(@item).to be_valid
    end
    it '価格が9,999,999円以下であること' do
      @item.price = 10_000_000
      @item.valid?
      expect(@item.errors.full_messages).to include('Price is out of setting range.')
      @item.price = 9_999_999
      expect(@item).to be_valid
    end
    it '販売価格は半角数字のみ入力可能であること' do
      @item.price = '１０００'
      @item.valid?
      expect(@item.errors.full_messages).to include('Price is invalid. Input half-width numbers.')
    end
  end
end
