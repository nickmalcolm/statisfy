class Country < ActiveRecord::Base
  
  has_many :crowns
  has_many :orders
  
  validates :name, presence: {allow_blank: false}
  validates :code, presence: {allow_blank: false}
  
  attr_accessible :name
  
  def reigning_crown
    crowns.reigning.first
  end
  
end
