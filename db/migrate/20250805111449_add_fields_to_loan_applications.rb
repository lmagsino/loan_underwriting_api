class AddFieldsToLoanApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :loan_applications, :purpose, :text
    add_column :loan_applications, :employment_status, :integer, default: 0
    add_column :loan_applications, :annual_income, :decimal, precision: 12, scale: 2
    add_column :loan_applications, :monthly_expenses, :decimal, precision: 10, scale: 2
    add_column :loan_applications, :existing_debts, :decimal, precision: 12, scale: 2
    
    add_index :loan_applications, :employment_status
  end
end