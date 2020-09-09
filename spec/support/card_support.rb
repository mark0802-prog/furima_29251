module CardSupport
  def card_register
    # ニックネームをクリックすると、マイページに遷移する
    click_on @user.nickname
    # 「登録する」ボタンをクリックすると、カード登録画面に遷移する
    click_on '登録する'
    # 正しい情報を入力する
    fill_in 'card-number', with: 4_242_424_242_424_242
    fill_in 'card-exp-month', with: 12
    fill_in 'card-exp-year', with: 24
    fill_in 'card-cvc', with: 123
    # 登録ボタンを押すと、カードトークンと顧客トークンが生成され、データベースに保存される
    expect do
      click_on '登録'
      expect(page).to have_content('カード番号')
      expect(page).to have_content('有効期限')
      expect(page).to have_content('変更する')
    end.to change { Card.count }.by(1)
  end
end
