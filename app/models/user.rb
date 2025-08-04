# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  
  # Associations
  has_many :loan_applications, dependent: :destroy
  has_many :bank_accounts, dependent: :destroy
  has_many :transactions, through: :bank_accounts
  
  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }, 
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  validates :phone, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  
  # Enums
  enum role: { borrower: 0, lender: 1, admin: 2 }
  
  # Callbacks
  before_save :normalize_email
  
  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def latest_application
    loan_applications.order(created_at: :desc).first
  end
  
  private
  
  def normalize_email
    self.email = email.downcase.strip
  end
end