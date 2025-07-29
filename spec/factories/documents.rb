FactoryBot.define do
  factory :document do
    loan_application { nil }
    document_type { 1 }
    file_url { "MyString" }
    original_filename { "MyString" }
    file_size { 1 }
    uploaded_at { "2025-07-29 17:13:10" }
  end
end
