class Order < ActiveRecord::Base
  belongs_to :shop
  belongs_to :country
  
  validates :shop, presence: true
  validates :shopify_id, presence: true, uniqueness: true
  
end
