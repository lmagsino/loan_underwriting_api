# db/migrate/xxx_create_transactions.rb
class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :bank_account, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :transaction_type
      t.string :category
      t.string :description
      t.date :date, null: false
      t.string :merchant_name
      t.timestamps
    end
    
    add_index :transactions, :date
    add_index :transactions, :category
    add_index :transactions, [:bank_account_id, :date]
  end
end