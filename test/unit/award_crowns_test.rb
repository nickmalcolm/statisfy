require 'test_helper'

class AwardTest < ActiveSupport::TestCase
  
  test "perform calls on every country" do
    (country1 = mock()).expects(:id).once
    (country2 = mock()).expects(:id).once
    Country.expects(:all).returns([country1, country2])
    AwardCrowns.perform()
  end
  
  test "perform enqueues award country crown job" do
    (country1 = mock()).stubs(:id).returns(1)
    (country2 = mock()).stubs(:id).returns(3)
    Country.stubs(:all).returns([country1, country2])
    
    Resque.expects(:enqueue).once.with(AwardCountryCrown, 1)
    Resque.expects(:enqueue).once.with(AwardCountryCrown, 3)
    
    AwardCrowns.perform()
  end
  
end