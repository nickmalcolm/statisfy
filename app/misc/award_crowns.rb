class AwardCrowns
  @queue = :award
  
  def self.perform
    Shop.all.each do |s|
      Resque.enqueue(Sync::FetchShopOrders, s.id)
    end
    Country.all.each do |c|
      Resque.enqueue(AwardCountryCrown, c.id)
    end
  end
  
end  