# db/migrate/xxx_create_loan_applications.rb
class CreateLoanApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :loan_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :loan_type, default: 0
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.integer :status, default: 0
      t.integer :risk_score
      t.text :decision_reason
      t.datetime :applied_at
      t.datetime :decided_at
      t.timestamps
    end
    
    add_index :loan_applications, :status
    add_index :loan_applications, :applied_at
    add_index :loan_applications, [:user_id, :status]
  end
end