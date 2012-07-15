class AddMoreAttributesToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :total_price_usd,     :decimal, precision: 12, scale: 2
    add_column :orders, :total_price,         :decimal, precision: 12, scale: 2
    add_column :orders, :currency,            :string
    add_column :orders, :financial_status,    :string
    add_column :orders, :fulfillment_status,  :string
  end
end
