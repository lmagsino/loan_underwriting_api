# db/migrate/xxx_create_documents.rb
class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.references :loan_application, null: false, foreign_key: true
      t.integer :document_type, null: false
      t.string :file_url, null: false
      t.string :original_filename, null: false
      t.integer :file_size
      t.datetime :uploaded_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamps
    end
    
    add_index :documents, :document_type
  end
end