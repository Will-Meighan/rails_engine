FactoryBot.define do
  factory :invoice_item do
    quantity { 1 }
    unit_price { 1.5 }
    association :item
    association :invoice
  end
end
