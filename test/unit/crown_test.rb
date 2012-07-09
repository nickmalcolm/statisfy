require 'test_helper'

class CrownTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert FactoryGirl.create(:crown).valid?
  end
  
  test "requires shop" do
    assert FactoryGirl.build(:crown, shop: nil).invalid?
  end
  
  test "requires country" do
    assert FactoryGirl.build(:crown, country: nil).invalid?
  end
  
  test "new crown reigns" do
    crown = FactoryGirl.create(:crown)
    assert crown.reigns?
  end
    
  test "crown with lost at does not reign" do
    crown = FactoryGirl.create(:crown, lost_at: 5.days.ago)
    assert !crown.reigns?
  end
  
  test "reigning crowns scope" do
    crown1 = FactoryGirl.create(:crown)
    crown2 = FactoryGirl.create(:crown, lost_at: 5.days.ago)
    assert_equal 1, Crown.reigning.count
    assert_equal [crown1], Crown.reigning
  end
  
end
