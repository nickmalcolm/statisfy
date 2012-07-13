require 'test_helper'

class AwardCountryCrownTest < ActiveSupport::TestCase
  
  test "perform calls find_ruler on country" do
    country = mock()
    country.expects(:find_ruler).once
    Country.expects(:find_by_id).with(-1).returns(country)
    AwardCountryCrown.perform(-1)
  end
  
end