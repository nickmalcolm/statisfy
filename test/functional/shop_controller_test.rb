require 'test_helper'

class ShopControllerTest < ActionController::TestCase
  
  setup do
    @shop = Factory(:shop)
  end
  
  test "should get show" do
    get :show, id: @shop.id
    assert_response :success
  end
  
  test "should show no crowns" do
    get :show, id: @shop.id
    assert_select ".crown", 0
  end
  
  test "should show current rulings" do
    crown = Factory(:crown, shop: @shop)
    get :show, id: @shop.id
    assert_select ".current_crowns" do
      assert_select "#crown_#{crown.id} h4",  crown.country.name
    end
  end
  
  test "should show old rulings" do
    crown = Factory(:crown, shop: @shop, lost_at: 5.days.ago)
    get :show, id: @shop.id
    assert_select ".old_crowns" do
      assert_select "#crown_#{crown.id} strong", "#{crown.country.name}"
    end
  end
    

end
