require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  
  test "perform calls every shop" do
    (shop1 = mock()).expects(:id).once
    (shop2 = mock()).expects(:id).once
    Shop.expects(:all).returns([shop1, shop2])
    AwardCrowns.perform()
  end
  
  test "perform enqueues FetchShopOrders job" do
    (shop1 = mock()).stubs(:id).returns(1)
    (shop2 = mock()).stubs(:id).returns(3)
    Shop.stubs(:all).returns([shop1, shop2])
    
    Resque.expects(:enqueue).once.with(Sync::FetchShopOrders, 1)
    Resque.expects(:enqueue).once.with(Sync::FetchShopOrders, 3)
    
    AwardCrowns.perform()
  end
  
  test "perform calls on every country" do
    (country1 = mock()).expects(:id).once
    (country2 = mock()).expects(:id).once
    Country.expects(:all).returns([country1, country2])
    AwardCrowns.perform()
  end
  
  test "perform enqueues AwardCountryCrown job" do
    (country1 = mock()).stubs(:id).returns(1)
    (country2 = mock()).stubs(:id).returns(3)
    Country.stubs(:all).returns([country1, country2])
    
    Resque.expects(:enqueue).once.with(AwardCountryCrown, 1)
    Resque.expects(:enqueue).once.with(AwardCountryCrown, 3)
    
    AwardCrowns.perform()
  end
  
end