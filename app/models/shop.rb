class Shop < ActiveRecord::Base
  
  validates :myshopify_domain, presence: {allow_blank: false}, uniqueness: true
  
end