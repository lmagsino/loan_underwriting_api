# app/models/document.rb
class Document < ApplicationRecord
  belongs_to :loan_application
  
  validates :document_type, :file_url, :original_filename, presence: true
  validates :file_size, numericality: { greater_than: 0 }
  
  enum document_type: {
    identity: 0,
    income_proof: 1,
    bank_statement: 2,
    employment_letter: 3,
    tax_return: 4,
    other: 5
  }
  
  scope :by_type, ->(type) { where(document_type: type) }
end