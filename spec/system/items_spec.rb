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
        # 「新規投稿商品」をクリックすると、商品出品ページに遷移する
        click_on '新規投稿商品'
        # 商品を出品する
        display(@item)
        price_check_submit(@item)
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

  describe '商品一覧表示機能' do
    before do
      basic_auth
      # 出品処理
      @user = FactoryBot.create(:user)
      @item = []
      login(@user)
      3.times do |i|
        click_on '新規投稿商品'
        @item[i] = FactoryBot.build(:item)
        display(@item[i])
        image_path = Rails.root.join("public/images/test_image#{i}.png")
        attach_file('item-image', image_path)
        price_check_submit(@item[i])
        @item[i].id = Item.last[:id]
      end
      # //出品処理
    end

    it '複数出品した場合に、トップページで全ての商品が表示される' do
      # トップページに投稿した商品の画像・値段・商品名が表示される
      3.times do |i|
        expect(page).to have_selector("img[src$='test_image#{i}.png']")
        expect(page).to have_content(@item[i].price)
        expect(page).to have_content(@item[i].name)
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
      click_on '新規投稿商品'
      display(@item)
      price_check_submit(@item)
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
          expect(page).to have_content(@user.nickname)
          expect(page).to have_selector('img[src$="test_image.png"]')
          expect(page).to have_selector('img[src$="test_image0.png"]')
          item_info(@item)
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
          expect(page).to have_content(@user.nickname)
          expect(page).to have_selector('img[src$="test_image.png"]')
          expect(page).to have_selector('img[src$="test_image0.png"]')
          item_info(@item)
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
        expect(page).to have_content(@user.nickname)
        expect(page).to have_selector('img[src$="test_image.png"]')
        expect(page).to have_selector('img[src$="test_image0.png"]')
        item_info(@item)
      end
    end
  end

  describe '商品情報編集機能' do
    before do
      basic_auth
      # 出品処理
      @user = FactoryBot.create(:user)
      @item = FactoryBot.build(:item)
      login(@user)
      click_on '新規投稿商品'
      display(@item)
      price_check_submit(@item)
      @item.id = Item.last[:id]
      # //出品処理
    end

    context 'ログインしている場合' do
      context '出品者の場合' do
        before do
          # トップページに移動
          visit root_path
          # 商品をクリックすると詳細ページに移動する
          find('.item-img-content').click
          expect(current_path).to eq item_path(@item)
          # 商品詳細ページの「商品の編集」をクリックすると、商品情報編集ページに遷移する
          click_on '商品の編集'
          expect(current_path).to eq(edit_item_path(@item))
        end

        it '正しい情報を入力すると、商品情報の編集ができる（画像の編集は次の項目で実施）' do
          # 商品情報の更新
          @item2 = FactoryBot.build(:item)
          display(@item2)
          # 「変更する」ボタンをクリックすると、トップページに遷移する
          click_on '変更する'
          expect(current_path).to eq(root_path)
          # トップページに投稿した商品の画像・値段・商品名が表示される
          expect(page).to have_selector('img[src$="test_image.png"]')
          expect(page).to have_content(@item2.price)
          expect(page).to have_content(@item2.name)
        end
        it '画像の編集ができる' do
          # 画像の更新
          image_path = Rails.root.join('public/images/test_image1.png')
          image_path2 = Rails.root.join('public/images/test_image2.png')
          attach_file('item-image', image_path)
          attach_file('item_image_1', image_path2)
          # 「変更する」ボタンをクリックすると、トップページに遷移する
          click_on '変更する'
          expect(current_path).to eq(root_path)
          # トップページに投稿した商品の画像・値段・商品名が表示される
          expect(page).to have_selector('img[src$="test_image1.png"]')
          expect(page).to have_no_selector('img[src$="test_image2.png"]')
          expect(page).to have_content(@item.price)
          expect(page).to have_content(@item.name)
        end
        it '空欄などの正しくない情報にすると、エラーメッセージが表示され、データベースは更新されない' do
          fill_in 'item-name', with: ''
          fill_in 'item-price', with: ''
          # 「変更する」ボタンをクリックしても、移動しない
          click_on '変更する'
          expect(current_path).to eq(item_path(@item))
          # エラーメッセージが表示される
          expect(page).to have_selector('.error-message')
          # トップページの商品情報に変更はない
          visit root_path
          expect(page).to have_selector('img[src$="test_image.png"]')
          expect(page).to have_content(@item.price)
          expect(page).to have_content(@item.name)
        end
        it '商品情報編集ページでは登録済みの情報が表示されている' do
          expect(page).to have_content(@item.name && @item.info)
          expect(page).to have_select('item-category', selected: Category.find(@item.category_id)[:name])
          expect(page).to have_select('item-sales-status', selected: SalesStatus.find(@item.sales_status_id)[:name])
          expect(page).to have_select('item-shipping-fee-status',
                                      selected: ShippingFeeStatus.find(@item.shipping_fee_status_id)[:name])
          expect(page).to have_select('item-prefecture', selected: Prefecture.find(@item.prefecture_id)[:name])
          expect(page).to have_select('item-scheduled-delivery',
                                      selected: ScheduledDelivery.find(@item.scheduled_delivery_id)[:name])
          expect(page).to have_field('item-price', with: @item.price)
        end
        it '何も編集せずに更新をしても画像がなくならない' do
          # 情報の編集はおこなわない
          # 「変更する」ボタンをクリックすると、トップページに遷移する
          click_on '変更する'
          expect(current_path).to eq(root_path)
          # トップページの商品情報に画像が表示されている
          expect(page).to have_selector('img[src$="test_image.png"]')
          expect(page).to have_content(@item.price)
          expect(page).to have_content(@item.name)
        end
      end

      context '出品者ではない場合' do
        it '商品編集ページに移動ができず、トップページにリダイレクトされる' do
          # トップページに移動
          visit root_path
          # ログアウト
          click_on 'ログアウト'
          # 別のユーザでログイン
          @user2 = FactoryBot.create(:user)
          login(@user2)
          # 直接編集ページに遷移をしようとすると、トップページにリダイレクトされる
          visit edit_item_path(@item)
          expect(current_path).to eq(root_path)
        end
      end
    end

    context 'ログインしていない場合' do
      it '商品編集ページに移動ができず、ログインページにリダイレクトされる' do
        # トップページに移動
        visit root_path
        # ログアウト
        click_on 'ログアウト'
        # 直接編集ページに遷移をしようとすると、ログインページにリダイレクトされる
        visit edit_item_path(@item)
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

  describe '商品削除機能' do
    before do
      basic_auth
      # 出品処理
      @user = FactoryBot.create(:user)
      @item = FactoryBot.build(:item)
      login(@user)
      click_on '新規投稿商品'
      display(@item)
      price_check_submit(@item)
      @item.id = Item.last[:id]
      # //出品処理
    end

    context 'ログインしている場合' do
      context '出品者の場合' do
        it '商品を削除できる' do
          # トップページに移動
          visit root_path
          # 商品をクリックすると詳細ページに移動する
          find('.item-img-content').click
          expect(current_path).to eq item_path(@item)
          # 商品詳細ページの「削除」をクリックすると、商品情報がデータベースから削除される
          expect do
            click_on '削除'
          end.to change { Item.count }.by(-1)
          # トップページにリダイレクトされる
          expect(current_path).to eq(root_path)
          # 削除した商品の情報がトップページに表示されていない
          expect(page).to have_no_selector('img[src$="test_image.png"]')
          expect(page).to have_no_content(@item.price)
          expect(page).to have_no_content(@item.name)
        end
      end
    end
    # 上記以外では、削除のリンクが表示されないことを確認した
  end
end
