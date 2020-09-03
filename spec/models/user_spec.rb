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
      expect(@user.errors.full_messages).to include('ニックネームを入力してください')
    end
    it 'メールアドレスが必須であること' do
      @user.email = nil
      @user.valid?
      expect(@user.errors.full_messages).to include('Eメールを入力してください')
    end
    it 'メールアドレスが一意性であること' do
      @user2 = FactoryBot.create(:user)
      @user.email = @user2.email
      @user.valid?
      expect(@user.errors.full_messages).to include('Eメールはすでに存在します')
    end
    it 'メールアドレスは@を含む必要があること' do
      @user.email = Faker::Internet.username
      @user.valid?
      expect(@user.errors.full_messages).to include('Eメールは不正な値です')
    end
    it 'パスワードが必須であること' do
      @user.password = nil
      @user.valid?
      expect(@user.errors.full_messages).to include('パスワードを入力してください')
    end
    it 'パスワードは6文字以上であること' do
      @user.password = '12345'
      @user.password_confirmation = '12345'
      @user.valid?
      expect(@user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
    end
    it 'パスワードは半角英数字混合であること' do
      @user.password = '123456'
      @user.password_confirmation = '123456'
      @user.valid?
      expect(@user.errors.full_messages).to include('パスワードは半角英数字混合で入力してください')
    end
    it 'パスワードは確認用を含めて2回入力すること' do
      @user.password_confirmation = ''
      @user.valid?
      expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
    end
    it 'パスワード更新時も半角英数混合であること' do
      @user.save
      expect(@user.update(password: '123456', password_confirmation: '123456')).to be_falsey
      expect(@user.errors.full_messages).to include('パスワードは半角英数字混合で入力してください')
    end
    it 'ユーザ本名の名字が必須であること' do
      @user.first_name = nil
      @user.valid?
      expect(@user.errors.full_messages).to include('名字を入力してください')
    end
    it 'ユーザ本名の名前が必須であること' do
      @user.last_name = nil
      @user.valid?
      expect(@user.errors.full_messages).to include('名前を入力してください')
    end
    it 'ユーザ本名の名字は全角（漢字・ひらがな・カタカナ）であること' do
      @user.first_name = 'tanaka'
      @user.valid?
      expect(@user.errors.full_messages).to include('名字は全角で入力してください')
    end
    it 'ユーザ本名の名前は全角（漢字・ひらがな・カタカナ）であること' do
      @user.last_name = 'taro'
      @user.valid?
      expect(@user.errors.full_messages).to include('名前は全角で入力してください')
    end
    it 'ユーザ本名の名字のフリガナが必須であること' do
      @user.first_name_kana = nil
      @user.valid?
      expect(@user.errors.full_messages).to include('名字（カナ）を入力してください')
    end
    it 'ユーザ本名の名前のフリガナが必須であること' do
      @user.last_name_kana = nil
      @user.valid?
      expect(@user.errors.full_messages).to include('名前（カナ）を入力してください')
    end
    it 'ユーザ本名の名字のフリガナは全角（カタカナ）であること' do
      @user.first_name_kana = 'たなか'
      @user.valid?
      expect(@user.errors.full_messages).to include('名字（カナ）は全角カタカナで入力してください')
    end
    it 'ユーザ本名の名前のフリガナは全角（カタカナ）であること' do
      @user.last_name_kana = 'いちろう'
      @user.valid?
      expect(@user.errors.full_messages).to include('名前（カナ）は全角カタカナで入力してください')
    end
    it '生年月日が必須であること' do
      @user.birth_date = nil
      @user.valid?
      expect(@user.errors.full_messages).to include('生年月日を入力してください')
    end
  end
end
