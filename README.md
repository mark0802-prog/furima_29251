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
|postal-code|string|null: false|
|prefecture|string|null: false|
|city|string|null: false|
|addresses|string|null: false|
|building|string||
|phone-number|integer|null: false|
|user|references|null: false, foreign_key: true|
|item|references|null: false, foreign_key: true|

### Association

- belongs_to :user
- belongs_to :item

## itemsテーブル

|Column|Type|Options|
|---|---|---|
|name|string|null: false|
|info|string|null: false|
|category|string|null: false|
|sales-status|string|null: false|
|shipping-fee-status|string|null: false|
|prefecture|string|null: false|
|scheduled-delivery|string|null: false|
|price|integer|null: false|
|user|references|null: false, foreign_key: true|

### Association

- belongs_to :user
- has_one :transaction
- has_one_attached :image
