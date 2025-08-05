# Add these fields to app/models/loan_application.rb
class LoanApplication < ApplicationRecord
  belongs_to :user
  has_many :documents, dependent: :destroy
  
  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0, less_than: 1_000_000 }
  validates :loan_type, presence: true
  validates :purpose, presence: true, length: { minimum: 10, maximum: 500 }
  validates :employment_status, presence: true
  validates :annual_income, presence: true, numericality: { greater_than: 0 }
  validates :monthly_expenses, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :existing_debts, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  
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
  enum employment_status: {
    employed: 0,
    self_employed: 1,
    unemployed: 2,
    retired: 3,
    student: 4
  }
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :pending_review, -> { where(status: [:submitted, :under_review]) }
  
  # Callbacks
  before_save :set_applied_at, if: -> { status_changed? && submitted? }
  
  # Instance methods
  def decision_time_minutes
    return nil unless decided_at && applied_at
    ((decided_at - applied_at) / 1.minute).round
  end
  
  def can_be_submitted?
    draft? && documents.exists? && valid?
  end
  
  def debt_to_income_ratio
    return 0 if annual_income.nil? || annual_income.zero?
    ((existing_debts || 0) / annual_income * 100).round(2)
  end
  
  def monthly_debt_service
    (existing_debts || 0) / 12
  end
  
  private
  
  def set_applied_at
    self.applied_at = Time.current
  end
end