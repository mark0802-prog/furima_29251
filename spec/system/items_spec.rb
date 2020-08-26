require 'rails_helper'

RSpec.describe "商品管理機能", type: :system do
  describe '商品出品機能' do
    before do
      basic_auth
    end

    context 'ログインしている場合' do
      before do
        @user = FactoryBot.create(:user)
        @item = FactoryBot.build(:item)
        login(@user)
      end

      it '正しい情報の場合、商品が出品できる' do
        #「新規投稿商品」をクリックすると、商品出品ページに遷移する
        click_on '新規投稿商品'
        #正しい情報を入力する
        image_path = Rails.root.join('public/images/test_image.png')
        attach_file('item-image', image_path)
        fill_in 'item-name', with: @item.name
        fill_in 'item-info', with: @item.info
        select Category.find(@item.category_id)[:name], from: 'item-category'
        select SalesStatus.find(@item.sales_status_id)[:name], from: 'item-sales-status'
        select ShippingFeeStatus.find(@item.shipping_fee_status_id)[:name], from: 'item-shipping-fee-status'
        select Prefecture.find(@item.prefecture_id)[:name], from: 'item-prefecture'
        select ScheduledDelivery.find(@item.scheduled_delivery_id)[:name], from: 'item-scheduled-delivery'
        fill_in 'item-price', with: @item.price
        #価格を入力すると、販売手数料と利益が表示される
        price = @item.price.to_i
        add_tax_price = (price*0.1).to_i
        profit = @item.price.to_i - add_tax_price
        expect(page).to have_content(add_tax_price)
        expect(page).to have_content(profit)
        #「出品する」をクリックすると、商品情報が保存される
        expect {
          click_on '出品する'
        }.to change {Item.count}.by(1)
        #トップページに遷移する
        expect(current_path).to eq(root_path)
        #トップページに投稿した商品の画像・値段・商品名が表示される
        expect(page).to have_selector('img[src$="test_image.png"]')
        expect(page).to have_content(@item.price)
        expect(page).to have_content(@item.name)
      end
      it '「出品する」ボタンからでも商品出品ページに移動できる' do
        find(".purchase-btn-icon").click
        expect(current_path).to eq(new_item_path)
      end
      it '情報を入力しない場合、商品が出品できない' do
        #「新規投稿商品」をクリックすると、商品出品ページに遷移する
        click_on '新規投稿商品'
        #情報を入力しない
        #「出品する」を押しても、商品情報が保存されない
        expect {
          click_on '出品する'
        }.to change {Item.count}.by(0)
        #商品出品ページから移動しない
        expect(current_path).to eq(items_path)
        #商品出品ページにエラーが表示される
        expect(page).to have_selector('.error-message')
      end
    end

    context 'ログアウトしている場合' do
      before do
        visit root_path
      end

      it '新規投稿をしようとすると、ログインページに遷移する' do
        #「新規投稿商品」をクリックすると、ログインページに遷移する
        click_on '新規投稿商品'
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

  describe '商品詳細表示機能' do
    
  end

  describe '商品情報編集機能' do
    
  end

  describe '商品削除機能' do
    
  end
end
