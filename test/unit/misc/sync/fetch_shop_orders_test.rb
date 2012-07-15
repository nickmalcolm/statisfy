require 'test_helper'
class FetchShopOrdersTest < ActiveSupport::TestCase
  
  setup do
    @shop = Factory(:shop, access_token: "ABC")
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
        fields: "id,shipping_address",
        since_id: nil
      }
    ).returns([])
    
    Sync::FetchShopOrders.perform(@shop.id)
  end
  
  test "can't fetch any orders with 0 credit_left" do
    ShopifyAPI::Order.expects(:count).once.returns(250) # 250 Orders to fetch
    ShopifyAPI.expects(:credit_left).once.returns(0) # 0 API call left
    
    ShopifyAPI::Order.expects(:find).never
    
    Sync::FetchShopOrders.perform(@shop.id)
  end
  
  test "can fetch 500 orders with 2 credit_left" do
    ShopifyAPI::Order.expects(:count).once.returns(500)
    ShopifyAPI.expects(:credit_left).once.returns(2)
    
    ShopifyAPI::Order.expects(:find).twice.returns([])
    
    Sync::FetchShopOrders.perform(@shop.id)
  end
  
  test "can fetch oldest 250/500 orders with 1 credit_left" do
    ShopifyAPI::Order.expects(:count).once.returns(500)
    ShopifyAPI.expects(:credit_left).once.returns(1)
    
    ShopifyAPI::Order.expects(:find).once.with(
      :all,
      params: {
        limit: 250,
        page: 2,
        fields: "id,shipping_address",
        since_id: nil
      }
    ).returns([])
    
    Sync::FetchShopOrders.perform(@shop.id)
  end

  test "fetch uses since_id if shop has existing orders" do
    # Make shop.orders.maximum(:shopify_id) return 1234
    orders = mock()
    orders.expects(:maximum).with(:shopify_id).once.returns(1234)
    @shop.expects(:orders).once.returns(orders)
    Shop.expects(:find_by_id).returns(@shop)

    ShopifyAPI::Order.expects(:count).with({since_id: 1234}).once.returns(1)
    ShopifyAPI.stubs(:credit_left).returns(500)

    ShopifyAPI::Order.expects(:find).once.with(
      :all,
      params: {
        limit: 250,
        page: 1,
        fields: "id,shipping_address",
        since_id: 1234
      }
    ).returns([])

    Sync::FetchShopOrders.perform(@shop.id)
  end
  
  test "fetch calls ingest_order for each Shopify order" do
    ShopifyAPI::Order.stubs(:count).returns(5)
    ShopifyAPI.stubs(:credit_left).returns(500)
    ShopifyAPI::Order.stubs(:find).returns([mock(),mock(),mock(),mock(),mock()])
    
    Sync::FetchShopOrders.expects(:ingest_order).times(5)
    Sync::FetchShopOrders.perform(@shop.id)
  end
  
end
class FetchIngestShopOrdersTest < ActiveSupport::TestCase
  
  setup do
    @shop = Factory(:shop, access_token: "ABC")
    
    @mock_order = mock()
    @mock_order.stubs(:id).returns(1234)
    %w(respond_to? total_price_usd total_price financial_status fulfillment_status currency).each do |attribute|
      @mock_order.send("stubs", attribute)
    end
  end
  
  
  test "ingest creates orders returned by Shopify" do
    assert_difference "Order.count" do
      Sync::FetchShopOrders.ingest_order(@mock_order, @shop.id)
    end
    
    order = Order.last
    assert_equal 1234, order.shopify_id
    assert_equal @shop, order.shop
  end
  
  test "ingest associates with existing country" do
    mock_shipping_address = mock()
    mock_shipping_address.expects(:country_code).returns("NZ")
    mock_shipping_address.expects(:country).returns("New Zealand")
    @mock_order.stubs(:respond_to?).with(:shipping_address).returns(true)
    @mock_order.stubs(:shipping_address).returns(mock_shipping_address)
    
    nz = FactoryGirl.create(:country, name: "New Zealand", code: "NZ")
    
    assert_no_difference "Country.count" do
      Sync::FetchShopOrders.ingest_order(@mock_order, @shop.id)
    end
    
    order = Order.last
    assert_equal nz, order.country
  end
  
  test "ingest creates new non-existant country" do
    mock_shipping_address = mock()
    mock_shipping_address.expects(:country_code).returns("NZ")
    mock_shipping_address.expects(:country).returns("New Zealand")
    @mock_order.stubs(:respond_to?).with(:shipping_address).returns(true)
    @mock_order.stubs(:shipping_address).returns(mock_shipping_address)
    
    assert_difference "Country.count" do
      Sync::FetchShopOrders.ingest_order(@mock_order, @shop.id)
    end
    country = Country.last
    assert_equal "NZ", country.code
    assert_equal "New Zealand", country.name
    
    order = Order.last
    assert_equal country, order.country
  end
  
  test "ingest can handle no shipping address" do
    @mock_order.expects(:respond_to?).with(:shipping_address).returns(false)
    Sync::FetchShopOrders.ingest_order(@mock_order, @shop.id)
    order = Order.last
    assert_nil order.country
  end
  
  test "can ingest prices" do
    @mock_order.expects(:total_price_usd).returns("0.00")
    @mock_order.expects(:total_price).returns("129.52")
    @mock_order.expects(:currency).returns("USD")
    Sync::FetchShopOrders.ingest_order(@mock_order, @shop.id)
    order = Order.last
    assert_equal "0.00".to_d, order.total_price_usd
    assert_equal "129.52".to_d, order.total_price
    assert_equal "USD", order.currency
  end
  
  test "can ingest financial_status" do
    @mock_order.expects(:financial_status).returns("paid")
    Sync::FetchShopOrders.ingest_order(@mock_order, @shop.id)
    order = Order.last
    assert_equal "paid", order.financial_status
  end
  
  test "can ingest fulfillment_status" do
    @mock_order.expects(:fulfillment_status).returns("unshipped")
    Sync::FetchShopOrders.ingest_order(@mock_order, @shop.id)
    order = Order.last
    assert_equal "unshipped", order.fulfillment_status
  end
  
end