ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha'

class ActiveSupport::TestCase
  
  def login_as(shop)
    sess = mock()
    sess.stubs(:url).returns(shop.try(:myshopify_domain))
    session[:shopify] = sess
  end
  
  teardown do
    ShopifyAPI::Base.clear_session
  end
  
end
