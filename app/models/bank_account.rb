class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  
  validates :institution_name, presence: true
  validates :account_id, uniqueness: true, allow_blank: true
  
  enum account_type: { checking: 0, savings: 1, credit: 2 }
end