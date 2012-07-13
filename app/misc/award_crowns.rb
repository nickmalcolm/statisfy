class AwardCrowns
  @queue = :award
  
  def self.perform
    Country.all.each do |c|
      Resque.enqueue(AwardCountryCrown, c.id)
    end
  end
  
end  