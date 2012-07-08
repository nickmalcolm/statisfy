class AddShopIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shop_id, :integer
    add_index :orders, :shop_id
  end
end
