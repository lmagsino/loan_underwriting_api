# db/migrate/xxx_create_bank_accounts.rb  
class CreateBankAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :account_id
      t.string :institution_name
      t.integer :account_type, default: 0
      t.decimal :balance, precision: 12, scale: 2
      t.boolean :is_primary, default: false
      t.datetime :connected_at
      t.timestamps
    end
    
    add_index :bank_accounts, :account_id, unique: true
    add_index :bank_accounts, [:user_id, :is_primary]
  end
end