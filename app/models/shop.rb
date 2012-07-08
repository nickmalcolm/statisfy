class Shop < ActiveRecord::Base
  
  validates :myshopify_domain, presence: {allow_blank: false}, uniqueness: true
  
  def shopify_session
    raise ArgumentError, "Cannot create Shopify session without access_token" unless access_token
    session = ShopifyAPI::Session.new(myshopify_domain, access_token)
    raise ArgumentError, "ShopifyAPI Session invalid" unless session.valid?
    ShopifyAPI::Base.activate_session(session)
  end
  
  def with_shopify_session
    shopify_session
    yield if block_given?
    ShopifyAPI::Base.clear_session
  end
  
  def update_from_shopify
    with_shopify_session do
      shopify_version = ShopifyAPI::Shop.current
      attrs = %w(domain country email name currency timezone shop_owner plan_name myshopify_domain)
      attrs.each do |attribute|
        self.send("#{attribute}=", shopify_version.send("#{attribute}"))
      end
      self.shopify_created_at = shopify_version.created_at
      self.save!
    end
  end
  
  def async_update_from_shopify
    Resque.enqueue(Sync, self.id)
  end

end 