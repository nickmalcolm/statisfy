class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_shop
    if sess = session[:shopify]
      Shop.find_by_myshopify_domain(sess.url)
    end
  end
end
