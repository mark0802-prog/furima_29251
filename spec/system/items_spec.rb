require 'rails_helper'

RSpec.describe '商品管理機能', type: :system do
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
        # 商品を出品する
        display(@item)
        price_check(@item)
        # トップページに遷移する
        expect(current_path).to eq(root_path)
        # トップページに投稿した商品の画像・値段・商品名が表示される
        expect(page).to have_selector('img[src$="test_image.png"]')
        expect(page).to have_content(@item.price)
        expect(page).to have_content(@item.name)
        # ログアウトをしても、トップページに投稿した商品の画像・値段・商品名が表示される
        click_on 'ログアウト'
        expect(page).to have_selector('img[src$="test_image.png"]')
        expect(page).to have_content(@item.price)
        expect(page).to have_content(@item.name)
      end
      it '「出品する」ボタンからでも商品出品ページに移動できる' do
        find('.purchase-btn-icon').click
        expect(current_path).to eq(new_item_path)
      end
      it '情報を入力しない場合、商品が出品できない' do
        # 「新規投稿商品」をクリックすると、商品出品ページに遷移する
        click_on '新規投稿商品'
        # 情報を入力しない
        # 「出品する」を押しても、商品情報が保存されない
        expect do
          click_on '出品する'
        end.to change { Item.count }.by(0)
        # 商品出品ページから移動しない
        expect(current_path).to eq(items_path)
        # 商品出品ページにエラーが表示される
        expect(page).to have_selector('.error-message')
      end
    end

    context 'ログアウトしている場合' do
      before do
        visit root_path
      end

      it '新規投稿をしようとすると、ログインページに遷移する' do
        # 「新規投稿商品」をクリックすると、ログインページに遷移する
        click_on '新規投稿商品'
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

  describe '商品詳細表示機能' do
    before do
      basic_auth
      # 出品処理
      @user = FactoryBot.create(:user)
      @item = FactoryBot.build(:item)
      login(@user)
      display(@item)
      price_check(@item)
      @item.id = Item.last[:id]
      # //出品処理
    end

    context 'ログインしている場合' do
      context '出品者の場合' do
        it '商品詳細をみることができ、商品の編集と削除ができる' do
          # トップページに移動
          visit root_path
          # 商品をクリックすると詳細ページに移動する
          find('.item-img-content').click
          expect(current_path).to eq item_path(@item)
          # 商品詳細ページに、「商品の編集」と「削除」のボタンがある
          expect(page).to have_content('商品の編集')
          expect(page).to have_content('削除')
          # 「購入画面に進む」のボタンがない
          expect(page).to have_no_content('購入画面に進む')
          # 商品の情報と出品者名が表示されている
          item_info(@user, @item)
        end
      end

      context '出品者ではない場合' do
        it '商品詳細をみることができ、商品の購入ができる' do
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
          # 商品詳細ページに、「商品の編集」と「削除」のボタンがない
          expect(page).to have_no_content('商品の編集')
          expect(page).to have_no_content('削除')
          # 「購入画面に進む」のボタンがある
          expect(page).to have_content('購入画面に進む')
          # 商品の情報と出品者名が表示されている
          item_info(@user, @item)
        end
      end
    end

    context 'ログインしていない場合' do
      it '商品詳細をみることができ、商品の購入に進むリンクがある' do
        # トップページに移動
        visit root_path
        # ログアウト
        click_on 'ログアウト'
        # 商品をクリックすると詳細ページに移動する
        find('.item-img-content').click
        expect(current_path).to eq item_path(@item)
        # 商品詳細ページに、「商品の編集」と「削除」のボタンがない
        expect(page).to have_no_content('商品の編集')
        expect(page).to have_no_content('削除')
        # 「購入画面に進む」のボタンがある
        expect(page).to have_content('購入画面に進む')
        # 商品の情報と出品者名が表示されている
        item_info(@user, @item)
      end
    end
  end

  describe '商品情報編集機能' do
  end

  describe '商品削除機能' do
  end
end
