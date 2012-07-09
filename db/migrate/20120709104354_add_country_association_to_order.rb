class AddCountryAssociationToOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :shipping_country_code
    add_column :orders, :country_id, :integer
    add_index :orders, :country_id
  end
end
