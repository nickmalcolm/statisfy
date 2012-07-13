require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  
  setup do
    @name = "swift-runte5994"
    Resque.stubs(:enqueue)
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
  
  test "finalize creates shop with access token" do
    #Stub out the ShopifyAPI
    session = mock()
    session.stubs(:url).returns("#{@name}.myshopify.com")
    session.stubs(:token).returns("123")
    ShopifyAPI::Session.expects(:new).once.with(@name, "ABC").returns(session)
    
    assert_difference "Shop.count" do
      @request.env['omniauth.auth'] = {'credentials' => {'token' => "ABC"}}
      get :finalize, shop: @name
    end
    shop = Shop.last
    assert_equal "#{@name}.myshopify.com", shop.myshopify_domain
    assert_equal "123", shop.access_token
  end
  
  test "finalize starts async shop update" do
    shop = mock()
    shop.expects(:async_update_from_shopify).once
    Shop.expects(:find_or_create_by_myshopify_domain).returns(shop)
    
    @request.env['omniauth.auth'] = {'credentials' => {'token' => "ABC"}}
    get :finalize, shop: @name
  end
  
  test "finalize doesn't duplicate existing shop" do
    FactoryGirl.create(:shop, myshopify_domain: "#{@name}.myshopify.com")
    assert_no_difference "Shop.count" do
      @request.env['omniauth.auth'] = {'credentials' => {'token' => "ABC"}}
      get :finalize, shop: @name
    end
  end
  
  test "finalize sets current_shop" do
    FactoryGirl.create(:shop, myshopify_domain: "#{@name}.myshopify.com")
    
    @request.env['omniauth.auth'] = {'credentials' => {'token' => "ABC"}}
    get :finalize, shop: @name
    
    assert_not_nil session[:shopify]
    assert_equal "#{@name}.myshopify.com", session[:shopify].url
  end

end
