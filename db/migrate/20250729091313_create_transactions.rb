class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :bank_account, null: false, foreign_key: true
      t.decimal :amount
      t.string :transaction_type
      t.string :category
      t.string :description
      t.date :date
      t.string :merchant_name

      t.timestamps
    end
  end
end
