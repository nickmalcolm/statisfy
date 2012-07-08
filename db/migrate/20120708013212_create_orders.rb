class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :shopify_id
      t.string :shipping_country_code

      t.timestamps
    end
  end
end
