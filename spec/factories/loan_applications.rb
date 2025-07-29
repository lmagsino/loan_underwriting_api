FactoryBot.define do
  factory :loan_application do
    user { nil }
    loan_type { 1 }
    amount { "9.99" }
    status { 1 }
    risk_score { 1 }
    decision_reason { "MyText" }
    applied_at { "2025-07-29 17:13:09" }
    decided_at { "2025-07-29 17:13:09" }
  end
end
