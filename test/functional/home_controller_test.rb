require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "index doesn't show crowns" do
    3.times {FactoryGirl.create(:crown)}
    get :index
    assert_select "li.crown", 0
  end
  
  test "logged in shows shop name" do
    login_as FactoryGirl.create(:shop, name: "$2 Shop")
    get :index
    assert_select "a.dropdown-toggle", "$2 Shop"
  end
  
  test "logged in index shows current crowns" do
    shop1 = FactoryGirl.create(:shop, name: "$2 Shop")
    shop2 = FactoryGirl.create(:shop, name: "Walmart")
    usa = FactoryGirl.create(:country, code: "US", name: "United States")
    nz  = FactoryGirl.create(:country, code: "NZ", name: "New Zealand")
    crown1 = FactoryGirl.create(:crown, country: usa, shop: shop2)
    crown2 = FactoryGirl.create(:crown, country: nz,  shop: shop2, lost_at: 5.minutes.ago)
    crown3 = FactoryGirl.create(:crown, country: nz,  shop: shop1)
    
    login_as shop1
    
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
