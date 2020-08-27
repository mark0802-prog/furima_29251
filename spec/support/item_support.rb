module ItemSupport
  def display(item)
    # 正しい情報を入力する
    image_path = Rails.root.join('public/images/test_image.png')
    attach_file('item-image', image_path)
    fill_in 'item-name', with: item.name
    fill_in 'item-info', with: item.info
    select Category.find(item.category_id)[:name], from: 'item-category'
    select SalesStatus.find(item.sales_status_id)[:name], from: 'item-sales-status'
    select ShippingFeeStatus.find(item.shipping_fee_status_id)[:name], from: 'item-shipping-fee-status'
    select Prefecture.find(item.prefecture_id)[:name], from: 'item-prefecture'
    select ScheduledDelivery.find(item.scheduled_delivery_id)[:name], from: 'item-scheduled-delivery'
    fill_in 'item-price', with: item.price
  end

  def price_check_submit(item)
    # 価格を入力すると、販売手数料と利益が表示される
    price = item.price.to_i
    add_tax_price = (price * 0.1).to_i
    profit = item.price.to_i - add_tax_price
    expect(page).to have_content(add_tax_price)
    expect(page).to have_content(profit)
    # 「出品する」をクリックすると、商品情報が保存される
    expect do
      click_on '出品する'
    end.to change { Item.count }.by(1)
  end

  def item_info(item)
    # 商品の情報が表示されている、画像と出品者名は除く
    expect(page).to have_content(item.name && item.info && Category.find(item.category_id)[:name] &&
    SalesStatus.find(item.sales_status_id)[:name] && ShippingFeeStatus.find(item.shipping_fee_status_id)[:name] &&
    Prefecture.find(item.prefecture_id)[:name] && ScheduledDelivery.find(item.scheduled_delivery_id)[:name] && item.price)
  end
end
