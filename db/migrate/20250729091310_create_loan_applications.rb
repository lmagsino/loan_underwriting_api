class CreateLoanApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :loan_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :loan_type
      t.decimal :amount
      t.integer :status
      t.integer :risk_score
      t.text :decision_reason
      t.datetime :applied_at
      t.datetime :decided_at

      t.timestamps
    end
  end
end
