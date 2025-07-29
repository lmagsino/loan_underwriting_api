# app/models/loan_application.rb
class LoanApplication < ApplicationRecord
  belongs_to :user
  has_many :documents, dependent: :destroy
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :loan_type, presence: true
  
  enum loan_type: { personal: 0, business: 1, auto: 2, mortgage: 3 }
  enum status: { 
    draft: 0, 
    submitted: 1, 
    under_review: 2, 
    approved: 3, 
    rejected: 4, 
    funded: 5 
  }
  
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  
  def decision_time
    return nil unless decided_at && applied_at
    ((decided_at - applied_at) / 1.minute).round
  end
end