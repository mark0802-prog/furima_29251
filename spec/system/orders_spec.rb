require 'rails_helper'

RSpec.describe '購入管理機能', type: :system do
  describe '商品購入機能' do
    before do
      basic_auth
      # 出品処理
      @user = FactoryBot.create(:user)
      @item = FactoryBot.build(:item)
      @order_address = FactoryBot.build(:order_address)
      login(@user)
      click_on '新規投稿商品'
      display(@item)
      price_check_submit(@item)
      @item.id = Item.last[:id]
      # //出品処理
    end

    context 'ログインしている場合' do
      context '出品者の場合' do
        it '購入ページに遷移できず、トップページにリダイレクトされる' do
          # トップページに移動
          visit root_path
          # 購入ページのurlを入れても、トップページにリダイレクトされる
          visit item_orders_path(@item)
          expect(current_path).to eq(root_path)
        end
      end

      context '出品者ではない場合' do
        context '正しい情報を入力した場合' do
          it '商品を購入でき、購入された商品にはsoldoutが表示される' do
            # トップページに移動
            visit root_path
            # ログアウト
            click_on 'ログアウト'
            # 別のユーザでログイン
            @user2 = FactoryBot.create(:user)
            login(@user2)
            # 商品をクリックすると詳細ページに移動する
            find('.item-img-content').click
            expect(current_path).to eq item_path(@item)
            # 「購入画面に進む」をクリックすると、商品購入画面に遷移する
            click_on '購入画面に進む'
            expect(current_path).to eq(item_orders_path(@item))
            # 正しい情報を入力する
            fill_in 'card-number', with: 4_242_424_242_424_242
            fill_in 'card-exp-month', with: 12
            fill_in 'card-exp-year', with: 24
            fill_in 'card-cvc', with: 123
            fill_in 'postal-code', with: @order_address.postal_code
            select Prefecture.find(@order_address.prefecture_id)[:name], from: 'prefecture'
            fill_in 'city', with: @order_address.city
            fill_in 'addresses', with: @order_address.addresses
            fill_in 'building', with: @order_address.building
            fill_in 'phone-number', with: @order_address.phone_number
            # 「購入」をクリックすると、購入情報と、配送先住所が保存される
            expect  do
              click_on '購入'
              expect(page).to have_content('Sold Out!!')
            end.to change { Order.count && Address.count }.by(1)
            # トップページに遷移する
            expect(current_path).to eq(root_path)
            # 購入した商品にsoldoutが表示される
            expect(page).to have_content('Sold Out!!')
            # 購入した商品の詳細ページに移動するとsoldoutが表示されている
            find('.item-img-content').click
            expect(page).to have_content('Sold Out!!')
            # 直接購入ページのurlを入れても、トップページにリダイレクトされる
            visit item_orders_path(@item)
            expect(current_path).to eq(root_path)
          end
        end

        context '誤った情報を入力した場合' do
          it '商品を購入できない' do
            # トップページに移動
            visit root_path
            # ログアウト
            click_on 'ログアウト'
            # 別のユーザでログイン
            @user2 = FactoryBot.create(:user)
            login(@user2)
            # 商品をクリックすると詳細ページに移動する
            find('.item-img-content').click
            expect(current_path).to eq item_path(@item)
            # 「購入画面に進む」をクリックすると、商品購入画面に遷移する
            click_on '購入画面に進む'
            expect(current_path).to eq(item_orders_path(@item))
            # 情報を入力しない
            # 「購入」をクリックしても、購入情報と、配送先住所が保存されない
            expect do
              click_on '購入'
            end.to change { Order.count && Address.count }.by(0)
            # 購入ページのまま
            expect(current_path).to eq(item_orders_path(@item))
            # エラーメッセージの表示
            expect(page).to have_selector('.error-message')
            # トップページに移動する
            visit root_path
            # 購入した商品にsoldoutが表示されない
            expect(page).to have_no_content('Sold Out!!')
            # 購入した商品の詳細ページに移動するとsoldoutが表示されている
            find('.item-img-content').click
            expect(page).to have_no_content('Sold Out!!')
            # 直接購入ページのurlを入れると、購入ページに移動する
            visit item_orders_path(@item)
            expect(current_path).to eq(item_orders_path(@item))
          end
        end
      end
    end

    context 'ログインしていない場合' do
      it '購入ページに遷移できず、ログインページにリダイレクトされる' do
        # トップページに移動
        visit root_path
        # ログアウト
        click_on 'ログアウト'
        # 購入ページのurlを入れても、トップページにリダイレクトされる
        visit item_orders_path(@item)
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end
end
