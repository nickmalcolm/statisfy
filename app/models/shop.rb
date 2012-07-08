class Shop < ActiveRecord::Base
  has_many :orders
  
  validates :myshopify_domain, presence: {allow_blank: false}, uniqueness: true
  
  def shopify_session
    raise ArgumentError, "Cannot create Shopify session without access_token" unless access_token
    
    # Don't create a duplicate new session - it just wastes an API call
    unless has_current_shopify_session?
      session = ShopifyAPI::Session.new(myshopify_domain, access_token)
      raise ArgumentError, "ShopifyAPI Session invalid" unless session.valid?
      ShopifyAPI::Base.activate_session(session)
    end
  end
  
  def has_current_shopify_session?
    ShopifyAPI::Base.site.eql?("https://#{self.myshopify_domain}/admin") && 
    ShopifyAPI::Base.headers["X-Shopify-Access-Token"].eql?(self.access_token)
  end
  
  def with_shopify_session
    shopify_session
    yield if block_given?
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
    Resque.enqueue(Sync::UpdateShop, self.id)
  end

end 