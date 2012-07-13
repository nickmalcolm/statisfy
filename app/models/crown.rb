class Crown < ActiveRecord::Base
  
  belongs_to :shop
  belongs_to :country
  
  validates :shop, presence: true
  validates :country, presence: true
  
  attr_accessible :lost_at
  
  scope :reigning, where(lost_at: nil)
  scope :lost, where("lost_at IS NOT ?", nil)
  
  def reigns?
    lost_at.nil?
  end
  
  def former_crown
    crowns = Crown.where("country_id = ? AND id < ?", self.country_id, self.id).order("lost_at DESC")
    crowns.first
  end
    
end
