require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  
  test "perform calls find_ruler on every country" do
    (country1 = mock()).expects(:find_ruler).once
    (country2 = mock()).expects(:find_ruler).once
    Country.expects(:all).returns([country1, country2])
    AwardCrowns.perform()
  end
  
end