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
      expect(@item.errors.full_messages).to include('出品画像を入力してください')
    end
    it '画像が複数枚でも保存できること' do
      @item.images = [fixture_file_upload('public/images/test_image0.png'),
                      fixture_file_upload('public/images/test_image1.png'), fixture_file_upload('public/images/test_image2.png')]
      expect(@item).to be_valid
    end
    it '商品名が必須であること' do
      @item.name = nil
      @item.valid?
      expect(@item.errors.full_messages).to include('商品名を入力してください')
    end
    it '商品の説明が必須であること' do
      @item.info = nil
      @item.valid?
      expect(@item.errors.full_messages).to include('商品の説明を入力してください')
    end
    it 'カテゴリーの情報が必須であること' do
      @item.category_id = 1
      @item.valid?
      expect(@item.errors.full_messages).to include('カテゴリーを選択してください')
    end
    it '商品の状態についての情報が必須であること' do
      @item.sales_status_id = 1
      @item.valid?
      expect(@item.errors.full_messages).to include('商品の状態を選択してください')
    end
    it '配送料の負担についての情報が必須であること' do
      @item.shipping_fee_status_id = 1
      @item.valid?
      expect(@item.errors.full_messages).to include('配送料の負担を選択してください')
    end
    it '発送元の地域についての情報が必須であること' do
      @item.prefecture_id = 1
      @item.valid?
      expect(@item.errors.full_messages).to include('発送元の地域を選択してください')
    end
    it '発送までの日数についての情報が必須であること' do
      @item.scheduled_delivery_id = 1
      @item.valid?
      expect(@item.errors.full_messages).to include('発送までの日数を選択してください')
    end
    it '価格についての情報が必須であること' do
      @item.price = nil
      @item.valid?
      expect(@item.errors.full_messages).to include('価格を入力してください')
    end
    it '価格が300円以上であること' do
      @item.price = 299
      @item.valid?
      expect(@item.errors.full_messages).to include('価格は¥300~¥9,999,999で設定してください')
      @item.price = 300
      expect(@item).to be_valid
    end
    it '価格が9,999,999円以下であること' do
      @item.price = 10_000_000
      @item.valid?
      expect(@item.errors.full_messages).to include('価格は¥300~¥9,999,999で設定してください')
      @item.price = 9_999_999
      expect(@item).to be_valid
    end
    it '販売価格は半角数字のみ入力可能であること' do
      @item.price = '１０００'
      @item.valid?
      expect(@item.errors.full_messages).to include('価格は半角数字で入力してください')
    end
  end
end
