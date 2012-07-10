class Crown < ActiveRecord::Base
  
  belongs_to :shop
  belongs_to :country
  
  validates :shop, presence: true
  validates :country, presence: true
  
  attr_accessible :lost_at
  
  scope :reigning, where(lost_at: nil)
  
  def reigns?
    lost_at.nil?
  end
    
end
