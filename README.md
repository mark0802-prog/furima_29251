# テーブル設計

## usersテーブル

|Column|Type|Options|
|---|---|---|
|nickname|string|null: false|
|email|string|null: false|
|password|string|null: false|
|password_confirmation|string|null: false|
|first_name|string|null: false|
|last_name|string|null: false|
|first_name_kana|string|null: false|
|last_name_kana|string|null: false|
|birth_date|date|null: false|

### Association

- has_many :orders
- has_many :items
- has_one :card
- has_many :sns_credentials

## ordersテーブル

|Column|Type|Options|
|---|---|---|
|user|references|null: false, foreign_key: true|
|item|references|null: false, foreign_key: true|

### Association

- belongs_to :user
- belongs_to :item
- has_one :address, dependent: :destroy

## itemsテーブル

|Column|Type|Options|
|---|---|---|
|name|text|null: false|
|info|text|null: false|
|category_id|integer|null: false|
|sales_status_id|integer|null: false|
|shipping_fee_status_id|integer|null: false|
|prefecture_id|integer|null: false|
|scheduled-delivery_id|integer|null: false|
|price|integer|null: false|
|user|references|null: false, foreign_key: true|

### Association

- belongs_to :user
- has_one :order, dependent: :destroy
- has_one_attached :image

## addressesテーブル

|Column|Type|Options|
|---|---|---|
|postal_code|string|null: false|
|prefecture_id|integer|null: false|
|city|string|null: false|
|addresses|string|null: false|
|building|string||
|phone_number|string|null: false|
|order|references|null: false, foreign_key: true|

### Association

- belongs_to :order

## cardsテーブル

|Column|Type|Options|
|---|---|---|
|card_token|string|null: false|
|customer_token|string|null: false|
|user|references|null: false, foreign_key: true|

### Association

- belongs_to :user

## sns_credentialsテーブル

|Column|Type|Options|
|---|---|---|
|provider|string||
|uid|string||
|user|references|foreign_key: true|

### Association

- belongs_to :user, optional: true
