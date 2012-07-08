require 'test_helper'

class ShopTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    shop = FactoryGirl.build(:shop)
    assert shop.valid?, "Factory should be valid"
    assert shop.save!, "Factory should save"
  end
  
  test "shop requires myshopify_domain" do
    assert FactoryGirl.build(:shop, myshopify_domain: nil).invalid?, "Should be invalid with nil myshopify_domain"
    assert FactoryGirl.build(:shop, myshopify_domain: "").invalid? , "Should be invalid with blank myshopify_domain"
  end
  
  test "shopify_domain must be unique" do
    FactoryGirl.create(:shop, myshopify_domain: "test.myshopify.com")
    assert FactoryGirl.build(:shop, myshopify_domain: "test.myshopify.com").invalid?
  end
  
  test "has_current_shopify_session? is true if Session matches domain and token" do
    # Make shopify_session believe there is a current ShopifyAPI::Base
    ShopifyAPI::Base.expects(:site).once.returns("https://test.myshopify.com/admin")
    ShopifyAPI::Base.expects(:headers).once.returns({'X-Shopify-Access-Token' => "ABC"})
    
    shop = FactoryGirl.create(:shop, myshopify_domain: "test.myshopify.com", access_token: "ABC")
    assert shop.has_current_shopify_session?
  end

  test "has_current_shopify_session? is false with different shop domain" do
    ShopifyAPI::Base.expects(:site).once.returns("https://other.myshopify.com/admin")
    ShopifyAPI::Base.expects(:headers).never # Won't evaluate second half of boolean statement

    shop = FactoryGirl.create(:shop, myshopify_domain: "test.myshopify.com", access_token: "ABC")
    assert !shop.has_current_shopify_session?
  end
  
  test "has_current_shopify_session? is false with stale token" do
    ShopifyAPI::Base.expects(:site).once.returns("https://test.myshopify.com/admin")
    ShopifyAPI::Base.expects(:headers).once.returns({'X-Shopify-Access-Token' => "stale"})
    
    shop = FactoryGirl.create(:shop, myshopify_domain: "test.myshopify.com", access_token: "ABC")
    assert !shop.has_current_shopify_session?
  end
  
  test "shopify_session without access token raises ArgumentError" do
    shop = FactoryGirl.create(:shop)
    assert_raises ArgumentError do
      shop.shopify_session
    end
  end
  
  test "shopify_session with access token creates and activates a ShopifyAPI::Session" do
    #Stub out a 'valid' session
    valid_session = mock()
    valid_session.stubs(:valid?).returns(true)
    ShopifyAPI::Session.expects(:new).with("test.myshopify.com", "ABC").once.returns(valid_session)
    ShopifyAPI::Base.expects(:activate_session).once.with(valid_session)
    
    shop = FactoryGirl.create(:shop, myshopify_domain: "test.myshopify.com", access_token: "ABC")
    shop.shopify_session
  end
  
  test "shopify_session does not create new ShopifyAPI::Session if has_current_shopify_session?" do
    shop = FactoryGirl.create(:shop, myshopify_domain: "test.myshopify.com", access_token: "ABC")
    shop.expects(:has_current_shopify_session?).once.returns(true)
    shop.shopify_session
    
    assert_nil ShopifyAPI::Base.site, "Base.site should be nil when there is no ShopifyAPI::Session"
  end
  
  test "invalid ShopifyAPI::Session raises Argument Error" do
    invalid_session = mock()
    invalid_session.stubs(:valid?).returns(false)
    ShopifyAPI::Session.expects(:new).with("test.myshopify.com", "HAX").once.returns(invalid_session)
    
    shop = FactoryGirl.create(:shop, myshopify_domain: "test.myshopify.com", access_token: "HAX")
    assert_raises ArgumentError do
      shop.shopify_session
    end
  end
  
  test "update_from_shopify saves ShopifyAPI attributes to Shop" do
    attributes = {
      country: "US",
      email: "steve@apple.com",
      name: "Apple Computers",
      currency: "USD",
      timezone: "(GMT-05:00) Eastern Time (US & Canada)",
      shop_owner: "Steve Jobs",
      plan_name: "enterprise",
      domain: "shop.apple.com",
      myshopify_domain: "apple.myshopify.com",
      created_at: "2007-12-31T19:00:00-05:00"
    }
    
    shopify_shop_stub = mock()
    attributes.each do |attribute, value|
      shopify_shop_stub.stubs(attribute).returns(value)
    end
    # Stub out the request and response from an actual Shopify shop
    ShopifyAPI::Shop.expects(:current).once.returns(shopify_shop_stub)
    
    shop = FactoryGirl.create(:shop, access_token: "ABC")
    shop.update_from_shopify
    shop.reload
    
    %w(country email name currency timezone shop_owner plan_name domain myshopify_domain).each do |attribute|
      assert_equal attributes[attribute.to_sym], shop.send("#{attribute}"), "#{attribute} incorrect"
    end
    assert_equal Time.zone.parse(attributes[:created_at]), shop.shopify_created_at
  end
  
  test "async_update_from_shopify queues Resque job" do
    shop = FactoryGirl.create(:shop)
    Resque.expects(:enqueue).once.with(Sync::UpdateShop, shop.id)
    shop.async_update_from_shopify
  end
  
end
