# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_07_29_091313) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "account_id"
    t.string "institution_name"
    t.integer "account_type"
    t.decimal "balance"
    t.boolean "is_primary"
    t.datetime "connected_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bank_accounts_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.bigint "loan_application_id", null: false
    t.integer "document_type"
    t.string "file_url"
    t.string "original_filename"
    t.integer "file_size"
    t.datetime "uploaded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_application_id"], name: "index_documents_on_loan_application_id"
  end

  create_table "loan_applications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "loan_type"
    t.decimal "amount"
    t.integer "status"
    t.integer "risk_score"
    t.text "decision_reason"
    t.datetime "applied_at"
    t.datetime "decided_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_loan_applications_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "bank_account_id", null: false
    t.decimal "amount"
    t.string "transaction_type"
    t.string "category"
    t.string "description"
    t.date "date"
    t.string "merchant_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_transactions_on_bank_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "bank_accounts", "users"
  add_foreign_key "documents", "loan_applications"
  add_foreign_key "loan_applications", "users"
  add_foreign_key "transactions", "bank_accounts"
end
