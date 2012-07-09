FactoryGirl.define do

  factory :shop do
    myshopify_domain { "#{Faker::Company.name.parameterize}#{rand.to_s[2..5]}.myshopify.com" }
  end
  
  factory :order do
    shop
    sequence :shopify_id
  end
  
  factory :crown do
    shop
    country
  end
  
  factory :country do
    name { Faker::Address.country }
    code { [*('A'..'Z')].sample(3).join }
  end
end