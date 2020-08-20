require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザ新規登録' do
    before do
      @user = FactoryBot.build(:user)
    end

    it '全ての値が正しく入力されていれば保存できること' do
      expect(@user).to be_valid
    end
    it 'ニックネームが必須であること' do
      @user.nickname = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Nickname can't be blank")
    end
    it 'メールアドレスが必須であること' do
      @user.email = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Email can't be blank")
    end
    it 'メールアドレスが一意性であること' do
      @user2 = FactoryBot.create(:user)
      @user.email = @user2.email
      @user.valid?
      expect(@user.errors.full_messages).to include("Email has already been taken")
    end
    it 'メールアドレスは@を含む必要があること' do
      @user.email = Faker::Internet.username
      @user.valid?
      expect(@user.errors.full_messages).to include("Email is invalid")
    end
    it 'パスワードが必須であること' do
      @user.password = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end
      it 'パスワードは6文字以上であること' do
        @user.password = '12345'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
    end
    it 'パスワードは半角英数字混合であること' do
      @user.password = '12345'
      @user.valid?
      expect(@user.errors.full_messages).to include("Password is invalid. Input half-width alphanumeric mixture.")
    end
    it 'パスワードは確認用を含めて2回入力すること' do
      @user.password_confirmation = ""
      @user.valid?
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end
    it 'ユーザ本名の名字が必須であること' do
      @user.first_name = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("First name can't be blank")
    end
    it 'ユーザ本名の名前が必須であること' do
      @user.last_name = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Last name can't be blank")
    end
    it 'ユーザ本名の名字は全角（漢字・ひらがな・カタカナ）であること' do
      @user.first_name = Faker::Name.first_name
      @user.valid?
      expect(@user.errors.full_messages).to include("First name is invalid. Input full-width characters.")
    end
    it 'ユーザ本名の名前は全角（漢字・ひらがな・カタカナ）であること' do
      @user.last_name = Faker::Name.last_name
      @user.valid?
      expect(@user.errors.full_messages).to include("Last name is invalid. Input full-width characters.")
    end
    it 'ユーザ本名の名字のフリガナが必須であること' do
      @user.first_name_kana = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("First name kana can't be blank")
    end
    it 'ユーザ本名の名前のフリガナが必須であること' do
      @user.last_name_kana = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Last name kana can't be blank")
    end
    it 'ユーザ本名の名字のフリガナは全角（カタカナ）であること' do
      @user.first_name_kana = 'たなか'
      @user.valid?
      expect(@user.errors.full_messages).to include("First name kana is invalid. Input full-width katakana characters.")
    end
    it 'ユーザ本名の名前のフリガナは全角（カタカナ）であること' do
      @user.last_name_kana = 'いちろう'
      @user.valid?
      expect(@user.errors.full_messages).to include("Last name kana is invalid. Input full-width katakana characters.")
    end
    it '生年月日が必須であること' do
      @user.birth_date = nil
      @user.valid?
      expect(@user.errors.full_messages).to include("Birth date can't be blank")
    end
  end
end
