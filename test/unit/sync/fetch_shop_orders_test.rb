require 'test_helper'
class FetchShopOrdersTest < ActiveSupport::TestCase
  
  setup do
    @shop_id = Factory(:shop, access_token: "ABC").id
  end
  
  test "perform raises ArgumentError if invalid shop id is given" do
    assert_raises ArgumentError do
      Sync::FetchShopOrders.perform(-1)
    end
  end
  
  test "can fetch 250 orders with 1 credit_left" do
    ShopifyAPI::Order.expects(:count).once.returns(250) # 250 Orders to fetch
    ShopifyAPI.expects(:credit_left).once.returns(1) # 1 API call left
    
    ShopifyAPI::Order.expects(:find).once.with(
      :all,
      params: {
        limit: 250,
        page: 1,
        fields: "id,shipping_address"
      }
    ).returns([])
    
    Sync::FetchShopOrders.perform(@shop_id)
  end
  
  test "can't fetch any orders with 0 credit_left" do
    ShopifyAPI::Order.expects(:count).once.returns(250) # 250 Orders to fetch
    ShopifyAPI.expects(:credit_left).once.returns(0) # 0 API call left
    
    ShopifyAPI::Order.expects(:find).never
    
    Sync::FetchShopOrders.perform(@shop_id)
  end
  
  test "can fetch 500 orders with 2 credit_left" do
    ShopifyAPI::Order.expects(:count).once.returns(500)
    ShopifyAPI.expects(:credit_left).once.returns(2)
    
    ShopifyAPI::Order.expects(:find).twice.returns([])
    
    Sync::FetchShopOrders.perform(@shop_id)
  end
  
  test "can fetch oldest 250/500 orders with 1 credit_left" do
    ShopifyAPI::Order.expects(:count).once.returns(500)
    ShopifyAPI.expects(:credit_left).once.returns(1)
    
    ShopifyAPI::Order.expects(:find).once.with(
      :all,
      params: {
        limit: 250,
        page: 2,
        fields: "id,shipping_address"
      }
    ).returns([])
    
    Sync::FetchShopOrders.perform(@shop_id)
  end
  
  test "fetch creates orders returned by Shopify" do
    ShopifyAPI::Order.stubs(:count).returns(1)
    ShopifyAPI.stubs(:credit_left).returns(500)
    
    mock_order = stub()
    mock_order.expects(:id).once.returns(1234)
    mock_shipping_address = stub()
    mock_shipping_address.expects(:country_code).once.returns("NZ")
    mock_order.expects(:shipping_address).once.returns(mock_shipping_address)
    
    ShopifyAPI::Order.stubs(:find).returns([mock_order])
    
    assert_difference "Order.count" do
      Sync::FetchShopOrders.perform(@shop_id)
    end
    
    order = Order.last
    assert_equal 1234, order.shopify_id
    assert_equal "NZ", order.shipping_country_code
    assert_equal Shop.find(@shop_id), order.shop
  end
  
end