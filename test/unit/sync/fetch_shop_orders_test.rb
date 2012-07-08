require 'test_helper'
class FetchShopOrdersTest < ActiveSupport::TestCase
  
  test "perform raises ArgumentError if invalid shop id is given" do
    assert_raises ArgumentError do
      Sync::FetchShopOrders.perform(-1)
    end
  end

end