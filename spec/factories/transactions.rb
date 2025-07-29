FactoryBot.define do
  factory :transaction do
    bank_account { nil }
    amount { "9.99" }
    transaction_type { "MyString" }
    category { "MyString" }
    description { "MyString" }
    date { "2025-07-29" }
    merchant_name { "MyString" }
  end
end
