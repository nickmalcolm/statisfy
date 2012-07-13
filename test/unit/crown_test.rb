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
  
  test "lost crowns scope" do
    crown1 = FactoryGirl.create(:crown)
    crown2 = FactoryGirl.create(:crown, lost_at: 5.days.ago)
    assert_equal 1, Crown.lost.count
    assert_equal [crown2], Crown.lost
  end
  
  test "crown knows who it bet" do
    country = FactoryGirl.create(:country)
    crown1 = country.crown(FactoryGirl.create(:shop))
    crown2 = country.crown(FactoryGirl.create(:shop))
    crown3 = country.crown(FactoryGirl.create(:shop))
    
    assert_equal crown2, crown3.former_crown, "Crown 3 should beat crown 2"
    assert_equal crown1, crown2.former_crown, "Crown 2 should beat crown 1"
  end
  
end
