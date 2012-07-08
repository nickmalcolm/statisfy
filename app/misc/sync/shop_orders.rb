class Sync::ShopOrders < Sync
  
  def self.perform(shop_id, page = 1)
    raise ArgumentError, "Shop #{shop_id} does not exist" unless (shop = Shop.find_by_id(shop_id))
    
    shop.with_shopify_session do
      
      count = ShopifyAPI::Order.count
      puts "Shop #{shop_id} has #{count} Orders"
      if count > 0
        order_details = []
        page += count.divmod(250).first
        while page > 0
          orders = ShopifyAPI::Order.find(:all, :params => {:limit => 250, :page => page})
          orders.each do |shopify_order|
            
            Order.create do |order|
              order.shopify_id = shopify_order.id
              order.shipping_country_code = shopify_order.shipping_address.country_code
            end
            
          end
          page -= 1
        end
      end
      
    end
  end
  
end