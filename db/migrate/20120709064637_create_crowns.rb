class CreateCrowns < ActiveRecord::Migration
  def change
    create_table :crowns do |t|
      t.string :country_code
      t.string :country_name
      t.references :shop
      t.datetime :lost_at

      t.timestamps
    end
    add_index :crowns, :shop_id
  end
end
