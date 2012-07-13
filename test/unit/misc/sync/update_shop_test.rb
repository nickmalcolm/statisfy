require 'test_helper'
class UpdateShopTest < ActiveSupport::TestCase
  
  test "perform raises ArgumentError if invalid shop id is given" do
    assert_raises ArgumentError do
      Sync::UpdateShop.perform(-1)
    end
  end
  
end 