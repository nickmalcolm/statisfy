class AddCountryReferenceToCrown < ActiveRecord::Migration
  def change
    remove_column :crowns, :country_code
    add_column :crowns, :country_id, :integer
    add_index :crowns, :country_id
  end
end
