class AwardCrowns
  @queue = :award
  
  def self.perform
    Country.all.each do |c|
      c.find_ruler
    end
  end
  
end  