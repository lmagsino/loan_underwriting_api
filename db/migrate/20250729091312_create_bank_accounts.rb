class CreateBankAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :account_id
      t.string :institution_name
      t.integer :account_type
      t.decimal :balance
      t.boolean :is_primary
      t.datetime :connected_at

      t.timestamps
    end
  end
end
