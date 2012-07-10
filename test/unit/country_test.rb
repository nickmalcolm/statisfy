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
class FindRulerOfCountryTest < ActiveSupport::TestCase
  
  setup do
    @shop1 = Factory(:shop)
    @shop2 = Factory(:shop)
    @country = Factory(:country)
  end
  
  test "one candidate when clear-cut" do
    Factory(:order, shop: @shop1, country: @country)
    Factory(:order, shop: @shop1, country: @country)
    Factory(:order, shop: @shop2, country: @country)
    
    candidates = @country.candidates
    assert_equal 1, candidates.count
    assert_equal @shop1.id, candidates[0].shop_id.to_i
  end
  
  test "one candidates becomes ruler" do
    mock = mock()
    mock.expects(:shop_id).once.returns(@shop2.id)
    @country.expects(:candidates).once.returns([mock])
    
    assert_difference "Crown.count" do
      @country.find_ruler
    end
    crown = Crown.last
    assert_equal @shop2, crown.shop
    assert_equal crown, @country.reigning_crown
  end
  
  test "ruler overthrows old crown" do
    crown = Factory(:crown, shop: @shop1, country: @country)
    
    mock = mock()
    mock.stubs(:shop_id).returns(@shop2.id)
    @country.stubs(:candidates).returns([mock])
    
    @country.find_ruler
    crown.reload
    assert_not_nil crown.lost_at, "An overthrown crown should not have nil lost_at"
  end
  
  test "ruler can't overthrow self" do
    crown = Factory(:crown, shop: @shop2, country: @country)
    
    mock = mock()
    mock.stubs(:shop_id).returns(@shop2.id)
    @country.stubs(:candidates).returns([mock])
    
    @country.find_ruler
    
    crown.reload
    assert_nil crown.lost_at, "An reigning crown should have nil lost_at"
  end
  
  test "two canidates for a tie" do
    Factory(:order, shop: @shop1, country: @country)
    Factory(:order, shop: @shop2, country: @country)
    
    candidates = @country.candidates
    assert_equal 2, candidates.count
  end
  
  test "a tie does not overthrow ruler" do
    crown = Factory(:crown, shop: @shop2, country: @country)
    @country.stubs(:candidates).returns([mock(),mock()])
    
    assert_no_difference "Crown.count" do
      @country.find_ruler
    end
    assert_equal crown, @country.reigning_crown
  end
  
end
