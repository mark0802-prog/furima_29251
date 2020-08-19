# テーブル設計

## usersテーブル

|Column|Type|Options|
|---|---|---|
|nickname|string|null: false|
|email|string|null: false|
|password|string|null: false|
|password-confirmation|string|null: false|
|first-name|string|null: false|
|last-name|string|null: false|
|first-name-kana|string|null: false|
|last-name-kana|string|null: false|
|birth-date|date|null: false|

### Association

- has_many :transactions
- has_many :items

## transactionsテーブル

|Column|Type|Options|
|---|---|---|
|user|references|null: false, foreign_key: true|
|item|references|null: false, foreign_key: true|

### Association

- belongs_to :user
- belongs_to :item
- has_one :address

## itemsテーブル

|Column|Type|Options|
|---|---|---|
|name|text|null: false|
|info|text|null: false|
|category|integer|null: false|
|sales-status|integer|null: false|
|shipping-fee-status|integer|null: false|
|prefecture|integer|null: false|
|scheduled-delivery|integer|null: false|
|price|integer|null: false|
|user|references|null: false, foreign_key: true|

### Association

- belongs_to :user
- has_one :transaction
- has_one_attached :image

## addressesテーブル

|Column|Type|Options|
|---|---|---|
|postal-code|string|null: false|
|prefecture|integer|null: false|
|city|string|null: false|
|addresses|string|null: false|
|building|string||
|phone-number|string|null: false|
|order|references|null: false, foreign_key: true|

### Association

- belongs_to :transaction