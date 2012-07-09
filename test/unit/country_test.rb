require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert FactoryGirl.build(:country).valid?
  end
  
  test "requires name" do
    assert FactoryGirl.build(:country, name: nil).invalid?
    assert FactoryGirl.build(:country, name: "").invalid?
  end
  
  test "requires code" do
    assert FactoryGirl.build(:country, code: nil).invalid?
    assert FactoryGirl.build(:country, code: "").invalid?
  end
  
end
