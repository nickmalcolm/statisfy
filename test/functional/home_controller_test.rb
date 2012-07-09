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
    crown2 = Factory(:crown, country: nz,  lost_at: 5.minutes.ago)
    crown3 = Factory(:crown, country: nz,  shop: shop1)
    
    get :index
    
    assert_select "li", class: "us", text: "Walmart rules over United States"
    assert_select "li", class: "nz", text: "$2 Shop rules over New Zealand"
  end

end
