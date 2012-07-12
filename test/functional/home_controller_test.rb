require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "index shows current crowns" do
    shop1 = Factory(:shop, name: "$2 Shop")
    shop2 = Factory(:shop, name: "Walmart")
    usa = Factory(:country, code: "US", name: "United States")
    nz  = Factory(:country, code: "NZ", name: "New Zealand")
    crown1 = Factory(:crown, country: usa, shop: shop2)
    crown2 = Factory(:crown, country: nz,  shop: shop2, lost_at: 5.minutes.ago)
    crown3 = Factory(:crown, country: nz,  shop: shop1)
    
    get :index
    
    assert_select "li", class: "us" do
      assert_select "h3", "United States"
      assert_select "li#crown_#{crown1.id}", "Walmart reigns."
    end
    assert_select "li", class: "nz" do
      assert_select "h3", "New Zealand"
      assert_select "li#crown_#{crown3.id}", "$2 Shop reigns."
      assert_select "li#crown_#{crown2.id}", "Walmart was usurped 5 minutes ago."
    end
    
  end

end
