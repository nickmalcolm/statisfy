require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert FactoryGirl.build(:order).valid?
  end
  
  test "requires shopify_id" do
    assert FactoryGirl.build(:order, shopify_id: nil).invalid?
  end
  
  test "requires unique shopify_id" do
    FactoryGirl.create(:order, shopify_id: 1)
    assert FactoryGirl.build(:order, shopify_id: 1).invalid?
  end
  
  test "requires associated shop" do
    assert FactoryGirl.build(:order, shop: nil).invalid?
  end
  
end
