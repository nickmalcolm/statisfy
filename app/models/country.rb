class Country < ActiveRecord::Base
  
  has_many :orders
  
  validates :name, presence: {allow_blank: false}
  validates :code, presence: {allow_blank: false}
end
