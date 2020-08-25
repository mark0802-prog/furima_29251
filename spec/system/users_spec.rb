require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe 'ユーザ新規登録' do
    before do
      @user = FactoryBot.build(:user)
      basic_auth
      visit root_path
    end

    it 'ユーザ登録成功時' do
      # トップページに「新規登録」ボタンがある
      click_on '新規登録'
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
    it 'ユーザ登録失敗時' do
      # トップページに「新規登録」ボタンがある
      click_on '新規登録'
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

    it 'ログイン成功時' do
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
    it 'ログイン失敗時' do
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
      expect(page).to have_content('Invalid Email or password.')
    end
  end

  describe 'ログアウト' do
    before do
      @user = FactoryBot.create(:user)
      basic_auth
      login_as(@user, scope: :user)
      visit root_path
    end

    it 'ログアウト成功時' do
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
end
