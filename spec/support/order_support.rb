module OrderSupport
  # 商品購入処理
  def order(user)
    # トップページに移動
    visit root_path
    # ログアウト
    click_on 'ログアウト'
    # ログイン
    login(user)
    # 商品をクリックすると詳細ページに移動する
    find('.item-img-content').click
    expect(current_path).to eq item_path(@item)
    # 「購入画面に進む」をクリックすると、商品購入画面に遷移する
    click_on '購入画面に進む'
    expect(current_path).to eq(item_orders_path(@item))
    # 正しい情報を入力する
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
  end
end
