require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  
  setup do
    @name = "swift-runte5994"
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "index should redirect to authenticate if shop param passed" do
    get :index, shop: @name
    assert_redirected_to authenticate_path(shop: @name)
  end

  test "authenticate with shop param redirects to auth path" do
    get :authenticate, shop: @name
    assert_redirected_to "/auth/shopify?shop=#{@name}"
  end
  
  test "authenticate without shop param redirects to root path" do
    get :authenticate
    assert_redirected_to root_path
  end
   
  test "finalize with omniauth sets session" do
    @request.env['omniauth.auth'] = {'credentials' => {'token' => "ABC"}}
    get :finalize, shop: @name
    assert shopify_session = session[:shopify]
    assert shopify_session.token = "ABC"
    assert shopify_session.url = "#{@name}.myshopify.com"
  end
  
  test "finalize creates shop" do
    assert_difference "Shop.count" do
      @request.env['omniauth.auth'] = {'credentials' => {'token' => "ABC"}}
      get :finalize, shop: @name
    end
    shop = Shop.last
    assert_equal "#{@name}.myshopify.com", shop.myshopify_domain
  end
  
  test "finalize doesn't duplicate existing shop" do
    FactoryGirl.create(:shop, myshopify_domain: "#{@name}.myshopify.com")
    assert_no_difference "Shop.count" do
      @request.env['omniauth.auth'] = {'credentials' => {'token' => "ABC"}}
      get :finalize, shop: @name
    end
  end

end