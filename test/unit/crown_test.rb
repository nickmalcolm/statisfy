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
  
end
