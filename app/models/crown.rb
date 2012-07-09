class Crown < ActiveRecord::Base
  
  belongs_to :shop
  belongs_to :country
  
  validates :shop, presence: true
  validates :country, presence: true
    
end
