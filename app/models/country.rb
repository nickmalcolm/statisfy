class Country < ActiveRecord::Base
  
  has_many :crowns
  has_many :orders
  
  validates :name, presence: {allow_blank: false}
  validates :code, presence: {allow_blank: false}
  
  attr_accessible :name
  
  def reigning_crown
    crowns.reigning.first
  end
  
  def find_ruler
    shops = self.candidates
    
    # Ties don't overthrow
    if shops.count.eql? 1
      shop = Shop.find_by_id(shops[0].shop_id)
      
      # Don't recrown
      unless shop.eql? reigning_crown.try(:shop)
        # Dethrone one
        reigning_crown.update_attributes(lost_at: Time.zone.now) if reigning_crown.present?
        # Crown another
        crowns.create! do |c|
          c.shop = shop
        end
      end
    end
  end
  
  def candidates
    Shop.find_by_sql(
      "SELECT shop_id, COUNT(shop_id) AS order_count 
        FROM orders
        WHERE orders.country_id = #{self.id}
        GROUP BY shop_id 
        HAVING COUNT(shop_id) = (SELECT COUNT(shop_id) 
                                   FROM orders 
                                   WHERE orders.country_id = #{self.id}
                                   GROUP BY shop_id 
                                   ORDER BY COUNT(shop_id) DESC 
                                   LIMIT 1)
    ")
  end
  
end
