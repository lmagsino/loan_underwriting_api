class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.references :loan_application, null: false, foreign_key: true
      t.integer :document_type
      t.string :file_url
      t.string :original_filename
      t.integer :file_size
      t.datetime :uploaded_at

      t.timestamps
    end
  end
end
