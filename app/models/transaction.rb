class Transaction < ApplicationRecord
  belongs_to :bank_account
  
  validates :amount, :date, presence: true
  validates :amount, numericality: true
  
  scope :income, -> { where('amount > 0') }
  scope :expenses, -> { where('amount < 0') }
  scope :recent, -> { order(date: :desc) }
end