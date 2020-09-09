require 'rails_helper'

RSpec.describe 'カード管理機能', type: :system do
  describe 'カード登録機能' do
    before do
      basic_auth
      Capybara.default_max_wait_time = 5
    end

    context 'ログインしている場合' do
      before do
        @user = FactoryBot.create(:user)
        login(@user)
      end

      context 'カードを登録している場合' do
        before do
          # カード登録処理
          card_register
          @card_id = Card.last[:id]
          # //カード登録処理
          #マイページにいる
        end

        it 'マイページに登録したカード情報が表示される' do
          # 「登録する」ボタンがない
          expect(page).to have_no_content('登録する')
          # 「カード番号」「有効期限」「変更する」がある
          expect(page).to have_content('カード番号')
          expect(page).to have_content('有効期限')
          expect(page).to have_content('変更する')
          # 登録したカード情報の下4桁と有効期限がある
          expect(page).to have_content("4242")
          expect(page).to have_content("12")
          expect(page).to have_content("24")
          #「変更する」ボタンをクリックすると、カード編集ページへ遷移する
          click_on "変更する"
          expect(current_path).to eq edit_card_path(@card_id)
        end
        it '正しい情報を入力すればカード情報を編集することができる' do
          # 「変更する」をクリックすると、カード編集ページに遷移する
          click_on "変更する"
          # 正しい情報を入力する
          fill_in 'card-number', with: 5_105_105_105_105_100
          fill_in 'card-exp-month', with: 3
          fill_in 'card-exp-year', with: 25
          fill_in 'card-cvc', with: 123
          # 更新ボタンを押すと、マイページにリダイレクトされる
          click_on "更新"
          expect(page).to have_content("会員情報")
          expect(current_path).to eq edit_user_registration_path
          # 更新した情報が表示されている
          expect(page).to have_content("5100")
          expect(page).to have_content("3")
          expect(page).to have_content("25")
        end
        it '誤った情報を入力するとエラーメッセージが表示され、カード情報は更新されない' do
          # 「変更する」をクリックすると、カード編集ページに遷移する
          click_on "変更する"
          # 情報を入力しない
          # 更新ボタンを押しても、移動しない
          click_on "更新"
          expect(current_path).to eq edit_card_path(@card_id)
          # エラーメッセージが表示される
          expect(page).to have_selector(".error-message")
          # マイページのカード情報に変更はない
          visit edit_user_registration_path
          expect(page).to have_content("4242")
          expect(page).to have_content("12")
          expect(page).to have_content("24")
        end
        it 'urlでカード登録ページに遷移しようとしても、マイページにリダイレクトされる' do
          # カード登録ページのurlを入れても、ログインページにリダイレクトされる
          visit cards_path
          expect(current_path).to eq edit_user_registration_path
        end
        it 'urlで自分以外のカード編集ページに遷移しようとしても、マイページにリダイレクトされる' do
          # ログアウト
          visit root_path
          click_on 'ログアウト'
          # 別のユーザでログイン
          @user2 = FactoryBot.create(:user)
          login(@user2)
          # カード編集ページへのurlを入れても、トップページにリダイレクトされる
          visit edit_card_path(@card_id)
          expect(current_path).to eq root_path
        end
      end

      context 'カードを登録していない場合' do
        it 'マイページからカード登録画面に遷移できる' do
          # ニックネームをクリックすると、マイページに遷移する
          click_on @user.nickname
          expect(current_path).to eq edit_user_registration_path
          # 「登録する」ボタンがある
          expect(page).to have_content('登録する')
          # 「カード番号」「有効期限」「変更する」の表示がない
          expect(page).to have_no_content('カード番号')
          expect(page).to have_no_content('有効期限')
          expect(page).to have_no_content('変更する')
          # 「登録する」ボタンをクリックすると、カード登録画面に遷移する
          click_on '登録する'
          expect(current_path).to eq cards_path
        end
        it '正しい情報を入力すれば、カードを登録できる' do
          # カード登録処理
          card_register
          # //カード登録処理
          # マイページにリダイレクトされる
          expect(current_path).to eq edit_user_registration_path
          # 登録したカード情報が表示されている
          expect(page).to have_content('4242')
          expect(page).to have_content('12')
          expect(page).to have_content('24')
        end
        it '誤った情報ではカードを登録できない' do
          # ニックネームをクリックすると、マイページに遷移する
          click_on @user.nickname
          # 「登録する」ボタンをクリックすると、カード登録画面に遷移する
          click_on '登録する'
          # 情報を入力しない
          # 登録ボタンを押しても、データベースに保存されない
          expect do
            click_on '登録'
          end.to change { Card.count }.by(0)
          # エラーメッセージが表示される
          expect(page).to have_selector('.error-message')
          # カード登録ページのまま
          expect(current_path).to eq cards_path
        end
      end
    end

    context 'ログインしていない場合' do
      it 'マイページに遷移しようとすると、ログインページにリダイレクトされる' do
        # マイページのurlを入れても、ログインページにリダイレクトされる
        visit edit_user_registration_path
        expect(current_path).to eq new_user_session_path
      end
      it 'カード登録ページに遷移しようとすると、ログインページにリダイレクトされる' do
        # カード登録ページのurlを入れても、ログインページにリダイレクトされる
        visit cards_path
        expect(current_path).to eq new_user_session_path
      end
      it 'カード編集ページに遷移しようとすると、ログインページにリダイレクトされる' do
        # ログイン
        @user = FactoryBot.create(:user)
        login(@user)
        # カード登録処理
        card_register
        @card_id = Card.last[:id]
        # //カード登録処理
        # ログアウト
        visit root_path
        click_on 'ログアウト'
        # カード編集ページのurlを入れても、ログインページにリダイレクトされる
        visit edit_card_path(@card_id)
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
