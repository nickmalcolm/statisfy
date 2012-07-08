FactoryGirl.define do

  factory :shop do
    myshopify_domain { "#{Faker::Company.name.parameterize}#{rand.to_s[2..5]}.myshopify.com" }
  end
  
  factory :order do
    sequence :shopify_id
  end
end