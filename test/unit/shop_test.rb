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
  
end
