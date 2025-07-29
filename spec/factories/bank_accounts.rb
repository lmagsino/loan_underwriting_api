FactoryBot.define do
  factory :bank_account do
    user { nil }
    account_id { "MyString" }
    institution_name { "MyString" }
    account_type { 1 }
    balance { "9.99" }
    is_primary { false }
    connected_at { "2025-07-29 17:13:11" }
  end
end
