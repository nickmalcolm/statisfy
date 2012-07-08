module Sync
  class FetchShopOrders
    SHOPIFY_PAGE_LIMIT = 250
    @queue = :sync
    
    # Will fetch all unsynced Orders for a Shop. Restricted by the ShopifyAPI limits.
    # 
    def self.perform(shop_id)
      raise ArgumentError, "Shop #{shop_id} does not exist" unless (shop = Shop.find_by_id(shop_id))
    
      shop.shopify_session
      last_synced_order_id = shop.orders.maximum(:shopify_id)
      
      count = ShopifyAPI::Order.count({since_id: last_synced_order_id})
      credit_left = ShopifyAPI.credit_left # Keep track of credit locally to save on API calls
      
      if count > 0
        # The number of pages required to get all Orders
        pages = (count/"#{SHOPIFY_PAGE_LIMIT}".to_d).ceil
        #Start on the last page
        page = pages 
        # The last page we can do with this many API calls left
        last_page = [0, pages-credit_left].max 
        
        # Go from the last page and do as many as we can
        while page > last_page
          
          orders = ShopifyAPI::Order.find(
              :all, 
              params: {
                limit: SHOPIFY_PAGE_LIMIT, 
                page: page,
                fields: "id,shipping_address",
                since_id: last_synced_order_id
              })
          
          orders.each do |shopify_order|
          
            Order.create do |order|
              order.shopify_id = shopify_order.id
              order.shipping_country_code = shopify_order.shipping_address.country_code
              order.shop_id = shop_id
            end
          
          end
          
          page -= 1
        end
      end
    end
    
  end
end