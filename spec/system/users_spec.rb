require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe 'ユーザ新規登録' do
    before do
      @user = FactoryBot.build(:user)
      basic_auth
      visit root_path
    end

    it '正しい情報の場合、ユーザ登録成功' do
      # トップページに「新規登録」ボタンがある
      click_on '新規登録'
      # 「<SNSアカウントを使用せずに登録>」ボタンがある
      click_on '<SNSアカウントを使用せずに登録>'
      # 情報を正しく入力する
      fill_in 'nickname', with: @user.nickname
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      fill_in 'password-confirmation', with: @user.password_confirmation
      fill_in 'first-name', with: @user.first_name
      fill_in 'last-name', with: @user.last_name
      fill_in 'first-name-kana', with: @user.first_name_kana
      fill_in 'last-name-kana', with: @user.last_name_kana
      select '1930', from: 'user_birth_date_1i'
      select '1', from: 'user_birth_date_2i'
      select '1', from: 'user_birth_date_3i'
      # 「会員登録」ボタンを押すとユーザ情報が保存される
      expect do
        click_on '会員登録'
      end.to change { User.count }.by(1)
      # トップページにリダイレクトされる
      expect(current_path).to eq(root_path)
      # トップページに「ユーザ名」と「ログアウト」が表示される
      expect(page).to have_link(@user.nickname)
      expect(page).to have_link('ログアウト')
      # トップページに「ログイン」と「新規登録」が表示されない
      expect(page).to have_no_link('ログイン')
      expect(page).to have_no_link('新規登録')
    end
    it '入力しない場合、ユーザ登録失敗' do
      # トップページに「新規登録」ボタンがある
      click_on '新規登録'
      # 「<SNSアカウントを使用せずに登録>」ボタンがある
      click_on '<SNSアカウントを使用せずに登録>'
      # 情報を入力しない
      # 「会員登録」ボタンを押してもユーザ情報が保存されない
      expect do
        click_on '会員登録'
      end.to change { User.count }.by(0)
      # ユーザ新規登録ページから移動しない
      expect(current_path).to eq('/users')
      # ユーザ新規登録ページにエラーメッセージが表示される
      expect(page).to have_selector('.error-message')
    end
  end

  describe 'ログイン' do
    before do
      @user = FactoryBot.create(:user)
      basic_auth
      visit root_path
    end

    it '登録ずみのユーザ情報の場合、ログイン成功' do
      # ログインページに移動する
      click_on 'ログイン'
      # 正しい情報を入力し、「ログイン」ボタンを押す
      fill_in 'email', with: @user.email
      fill_in 'password', with: @user.password
      click_on 'ログイン'
      # トップページにリダイレクトされる
      expect(current_path).to eq(root_path)
      # トップページに「ユーザ名」と「ログアウト」が表示される
      expect(page).to have_link(@user.nickname)
      expect(page).to have_link('ログアウト')
      # トップページに「ログイン」と「新規登録」が表示されない
      expect(page).to have_no_link('ログイン')
      expect(page).to have_no_link('新規登録')
    end
    it '未登録のユーザ情報の場合、ログイン失敗' do
      # ログインページに移動する
      click_on 'ログイン'
      # 間違った情報を入力する
      unregistered_user = FactoryBot.build(:user)
      fill_in 'email', with: unregistered_user.email
      fill_in 'password', with: unregistered_user.password
      click_on 'ログイン'
      # ログインページから移動しない
      expect(current_path).to eq(user_session_path)
      # エラーメッセージが表示される
      expect(page).to have_content('Eメールまたはパスワードが違います。')
    end
  end

  describe 'ログアウト' do
    before do
      @user = FactoryBot.create(:user)
      basic_auth
      login(@user)
    end

    it 'ログアウトボタンをクリックすると、ログアウト成功' do
      # ログアウトする
      click_on 'ログアウト'
      # トップページに「ユーザ名」と「ログアウト」が表示されない
      expect(page).to have_no_link(@user.nickname)
      expect(page).to have_no_link('ログアウト')
      # トップページに「ログイン」と「新規登録」が表示される
      expect(page).to have_link('ログイン')
      expect(page).to have_link('新規登録')
    end
  end

  describe 'sns認証' do
    before do
      basic_auth
      @user = FactoryBot.build(:user)
      OmniAuth.config.test_mode = true
      @params = { provider: 'facebook', uid: '123545', info: { name: @user.nickname, email: @user.email } }
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(@params)
      visit root_path
    end

    context 'facebookアカウントを連携していない場合' do
      it 'facebookアカウントでユーザ登録ができる' do
        # facebookアカウントを利用したユーザ新規登録ページへ移動
        click_on '新規登録'
        click_on '<facebookアカウントで登録>'
        # facebookアカウントの情報が表示されている
        expect(page).to have_field 'nickname', with: @user.nickname
        expect(page).to have_field 'email', with: @user.email
        # 情報を正しく入力する
        fill_in 'first-name', with: @user.first_name
        fill_in 'last-name', with: @user.last_name
        fill_in 'first-name-kana', with: @user.first_name_kana
        fill_in 'last-name-kana', with: @user.last_name_kana
        select '1930', from: 'user_birth_date_1i'
        select '1', from: 'user_birth_date_2i'
        select '1', from: 'user_birth_date_3i'
        # 「会員登録」ボタンを押すとユーザ情報が保存される
        expect do
          click_on '会員登録'
        end.to change { User.count }.by(1)
        # トップページにリダイレクトされる
        expect(current_path).to eq(root_path)
        # トップページに「ユーザ名」と「ログアウト」が表示される
        expect(page).to have_link(@user.nickname)
        expect(page).to have_link('ログアウト')
        # トップページに「ログイン」と「新規登録」が表示されない
        expect(page).to have_no_link('ログイン')
        expect(page).to have_no_link('新規登録')
      end
      it '誤った情報を入力した場合、エラーメッセージが表示される' do
        # facebookアカウントを利用したユーザ新規登録ページへ移動
        click_on '新規登録'
        click_on '<facebookアカウントで登録>'
        # 情報を入力しない
        # 「会員登録」ボタンを押してもユーザ情報が保存されない
        expect do
          click_on '会員登録'
        end.to change { User.count }.by(0)
        # ユーザ新規登録ページから移動しない
        expect(current_path).to eq('/users')
        # ユーザ新規登録ページにエラーメッセージが表示される
        expect(page).to have_selector('.error-message')
      end
      it 'facebookアカウントを連携できる' do
        # ログイン
        @user.save
        login(@user)
        # マイページに遷移する
        click_on @user.nickname
        # 「<facebookアカウントと連携>」ボタンをクリックすると、facebook情報がデータベースに保存される
        expect do
          click_on '<facebookアカウントと連携>'
        end.to change { SnsCredential.count }.by(1)
        # ログアウト
        visit root_path
        click_on 'ログアウト'
        # facebookアカウントでログインできる
        click_on 'ログイン'
        click_on '<facebookアカウントでログイン>'
        # トップページにリダイレクトされる
        expect(current_path).to eq(root_path)
        # トップページに「ユーザ名」と「ログアウト」が表示される
        expect(page).to have_link(@user.nickname)
        expect(page).to have_link('ログアウト')
      end
      it '既に連携ずみのアカウントの場合、連携できない' do
        # ログイン
        @user.save
        login(@user)
        # マイページに遷移する
        click_on @user.nickname
        # 「<facebookアカウントと連携>」ボタンをクリックすると、facebook情報がデータベースに保存される
        expect do
          click_on '<facebookアカウントと連携>'
        end.to change { SnsCredential.count }.by(1)
        # ログアウト
        visit root_path
        click_on 'ログアウト'
        # 別のユーザでログインする
        @user2 = FactoryBot.create(:user)
        login(@user2)
        # マイページに遷移する
        click_on @user2.nickname
        # 「<facebookアカウントと連携>」ボタンをクリックしても、データベースに保存されない
        expect do
          click_on '<facebookアカウントと連携>'
        end.to change { SnsCredential.count }.by(0)
        # トップページにリダイレクトされる
        expect(current_path).to eq root_path
        # ログアウト
        visit root_path
        click_on 'ログアウト'
        # facebookアカウントでログインする
        click_on 'ログイン'
        click_on '<facebookアカウントでログイン>'
        # トップページにリダイレクトされる
        expect(current_path).to eq(root_path)
        # トップページに@userの「ユーザ名」と「ログアウト」が表示される
        expect(page).to have_link(@user.nickname)
        expect(page).to have_link('ログアウト')
      end
    end

    context 'facebookアカウントを連携している場合' do
      before do
        @user.save
        @sns = SnsCredential.create(provider: @params[:provider], uid: @params[:uid], user_id: @user.id)
        visit root_path
      end

      it 'facebookアカウントでログインができる' do
        # facebookアカウントでログインできる
        click_on 'ログイン'
        click_on '<facebookアカウントでログイン>'
        # トップページにリダイレクトされる
        expect(current_path).to eq(root_path)
        # トップページに「ユーザ名」と「ログアウト」が表示される
        expect(page).to have_link(@user.nickname)
        expect(page).to have_link('ログアウト')
      end
      it 'facebookアカウントの連携を解除できる' do
        # ログイン
        login(@user)
        # マイページに遷移する
        click_on @user.nickname
        # 「<facebookアカウントの連携を解除>」ボタンをクリックすると、facebook情報がデータベースに保存される
        expect do
          click_on '<facebookアカウントの連携を解除>'
        end.to change { SnsCredential.count }.by(-1)
        # ログアウト
        visit root_path
        click_on 'ログアウト'
        # facebookアカウントでログインしようとすると、新規ユーザ登録画面へ遷移する
        click_on 'ログイン'
        click_on '<facebookアカウントでログイン>'
        expect(current_path).to eq(user_facebook_omniauth_callback_path)
      end
    end

    context '認証エラーが発生した場合' do
      before do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
        visit root_path
      end

      it 'トップページにリダイレクトされる' do
        # facebookアカウントを利用したユーザ新規登録ページへ移動
        click_on '新規登録'
        click_on '<facebookアカウントで登録>'
        # トップページにリダイレクトされる
        expect(current_path).to eq root_path
      end
    end
  end
end
