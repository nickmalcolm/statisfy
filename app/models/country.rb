class Country < ActiveRecord::Base
  validates :name, presence: {allow_blank: false}
  validates :code, presence: {allow_blank: false}
end
