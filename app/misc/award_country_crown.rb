class AwardCountryCrown
  @queue = :award
  
  def self.perform(country_id)
    Country.find_by_id(country_id).try(:find_ruler)
  end
  
end