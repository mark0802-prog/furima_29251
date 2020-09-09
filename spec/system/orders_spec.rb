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
        before do
          # ログアウト
          visit root_path
          click_on 'ログアウト'
          # 別のユーザでログイン
          @user2 = FactoryBot.create(:user)
          login(@user2)
        end

        context 'カード登録をしている場合' do
          before do
            #カード登録処理
            card_register(@user2)
          end

          context '正しい情報を入力した場合' do
            it '商品を購入でき、購入された商品にはsoldoutが表示される' do
              # 商品購入処理
              order(@user2)
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
              # 購入した商品の詳細ページに移動するとsoldoutが表示されていない
              find('.item-img-content').click
              expect(page).to have_no_content('Sold Out!!')
              # 直接購入ページのurlを入れると、購入ページに移動する
              visit item_orders_path(@item)
              expect(current_path).to eq(item_orders_path(@item))
            end
          end
        end

        context 'カード登録をしていない場合' do
          it '購入ページにアクセスしようとすると、カード登録ページにリダイレクトされる' do
            # トップページに移動
            visit root_path
            # 商品をクリックすると詳細ページに移動する
            find('.item-img-content').click
            expect(current_path).to eq item_path(@item)
            # 「購入画面に進む」をクリックすると、カード登録ページに遷移する
            click_on '購入画面に進む'
            expect(current_path).to eq(cards_path)
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

    context '購入済みの場合' do
      before do
        # ログアウト
        visit root_path
        click_on 'ログアウト'
        # 別のユーザでログイン
        @user2 = FactoryBot.create(:user)
        login(@user2)
        #カード登録処理（user2で登録）
        card_register(@user2)
        # 購入処理（user2で購入）
        order(@user2)
      end

      context 'ログインしている場合' do
        context '出品者の場合' do
          before do
            # ログアウト
            click_on 'ログアウト'
            # 出品者でログイン
            login(@user)
            # 商品詳細ページに移動
            find('.item-img-content').click
          end

          it '商品詳細ページに「削除」ボタンがある' do
            expect(page).to have_content('削除')
          end
          it '商品詳細ページに「商品の編集」、「購入画面に進む」ボタンがない' do
            expect(page).to have_no_content('商品の編集')
            expect(page).to have_no_content('購入画面に進む')
          end
          it '購入ページに遷移できず、トップページにリダイレクトされる' do
            # 購入ページのurlを入れても、トップページにリダイレクトされる
            visit item_orders_path(@item)
            expect(current_path).to eq(root_path)
          end
        end

        context '出品者ではない場合' do
          before do
            # 商品詳細ページに移動
            find('.item-img-content').click
          end

          it '商品詳細ページに「購入画面に進む」ボタンがない' do
            expect(page).to have_no_content('購入画面に進む')
          end
          it '購入ページに遷移できず、トップページにリダイレクトされる' do
            # 購入ページのurlを入れても、トップページにリダイレクトされる
            visit item_orders_path(@item)
            expect(current_path).to eq(root_path)
          end
        end
      end

      context 'ログインしていない場合' do
        before do
          # ログアウト
          click_on 'ログアウト'
          # 商品詳細ページに移動
          find('.item-img-content').click
        end

        it '商品詳細ページに「購入画面に進む」ボタンがない' do
          expect(page).to have_no_content('購入画面に進む')
        end
        it '購入ページに遷移できず、トップページにリダイレクトされる' do
          # 購入ページのurlを入れても、トップページにリダイレクトされる
          visit item_orders_path(@item)
          expect(current_path).to eq(new_user_session_path)
        end
      end
    end
  end
end
