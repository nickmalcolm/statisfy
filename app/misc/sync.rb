class Sync
  @queue = :sync

  def self.perform(shop_id)
    Shop.find_by_id(shop_id).update_from_shopify
  end
end