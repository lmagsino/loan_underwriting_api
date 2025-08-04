# app/models/loan_application.rb
class LoanApplication < ApplicationRecord
  belongs_to :user
  has_many :documents, dependent: :destroy
  
  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0, less_than: 1_000_000 }
  validates :loan_type, presence: true
  
  # Enums
  enum loan_type: { personal: 0, business: 1, auto: 2, mortgage: 3 }
  enum status: { 
    draft: 0, 
    submitted: 1, 
    under_review: 2, 
    approved: 3, 
    rejected: 4, 
    funded: 5 
  }
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :pending_review, -> { where(status: [:submitted, :under_review]) }
  
  # Callbacks
  before_create :set_applied_at
  
  # Instance methods
  def decision_time_minutes
    return nil unless decided_at && applied_at
    ((decided_at - applied_at) / 1.minute).round
  end
  
  def can_be_submitted?
    draft? && documents.exists?
  end
  
  private
  
  def set_applied_at
    self.applied_at = Time.current if submitted?
  end
end