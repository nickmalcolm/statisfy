class Sync::Shop < Sync
  
  def self.perform(shop_id)
    Shop.find_by_id(shop_id).update_from_shopify
  end
  
end