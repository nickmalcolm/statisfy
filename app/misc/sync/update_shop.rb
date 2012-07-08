module Sync
  class UpdateShop
    @queue = :sync
  
    def self.perform(shop_id)
      raise ArgumentError, "Shop #{shop_id} does not exist" unless (shop = Shop.find_by_id(shop_id))
      shop.update_from_shopify
    end
  end
end