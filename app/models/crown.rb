class Crown < ActiveRecord::Base
  
  belongs_to :shop
  
  validates :shop, presence: true
  validates :country_code, presence: true
    
end
