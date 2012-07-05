class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.integer :shopify_id
      t.string :country
      t.datetime :shopify_created_at
      t.string :domain
      t.string :email
      t.string :name
      t.string :currency
      t.string :timezone
      t.string :shop_owner
      t.string :plan_name
      t.string :myshopify_domain, null: false
      t.string :access_token

      t.timestamps
    end
  end
end
