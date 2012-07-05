FactoryGirl.define do
  factory :shop do
    myshopify_domain { "#{Faker::Company.name} #{rand.to_s[2..5]}".parameterize }
  end
end