# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  
  has_many :loan_applications, dependent: :destroy
  has_many :bank_accounts, dependent: :destroy
  has_many :transactions, through: :bank_accounts
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  validates :phone, presence: true
  
  enum role: { borrower: 0, lender: 1, admin: 2 }
  
  before_save :downcase_email
  
  private
  
  def downcase_email
    self.email = email.downcase
  end
end