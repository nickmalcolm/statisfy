class Shop < ActiveRecord::Base
  
  validates :myshopify_domain, presence: {allow_blank: false}, uniqueness: true
  
  def shopify_session
    raise ArgumentError, "Cannot create Shopify session without access_token" unless access_token
    session = ShopifyAPI::Session.new(myshopify_domain, access_token)
    raise ArgumentError, "ShopifyAPI Session invalid" unless session.valid?
    ShopifyAPI::Base.activate_session(session)
  end
  
end