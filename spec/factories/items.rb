FactoryBot.define do
  factory :item do
    name { "my items" }
    description { "my descrition" }
    unit_price { 1.5 }
    association :merchant
  end
end
