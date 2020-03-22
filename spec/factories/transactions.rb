FactoryBot.define do
  factory :transaction do
    credit_card_number { "1234123412341234" }
    credit_card_expiration_date { nil }
    result { 1 }
    association :invoice
  end
end
