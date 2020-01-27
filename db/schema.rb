ActiveRecord::Schema.define(version: 2020_01_24_125251) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contract_invoices", force: :cascade do |t|
    t.bigint "contract_id"
    t.string "contract_number", null: false
    t.datetime "issue_date", null: false
    t.datetime "due_date", null: false
    t.datetime "paid_date"
    t.datetime "purchase_date", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.decimal "fixed_fee", precision: 8, scale: 2, null: false
    t.decimal "additional_fee", precision: 8, scale: 2, null: false
    t.decimal "total_fee", precision: 8, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contract_id"], name: "index_contract_invoices_on_contract_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.string "number", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.decimal "fixed_fee_rate", precision: 8, scale: 4, null: false
    t.decimal "additional_fee_rate", precision: 8, scale: 4, null: false
    t.integer "days_included", null: false
    t.boolean "active", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["number", "active", "start_date", "end_date"], name: "indexContractsOnNumber&Active&StartDate&EndDate"
  end

end
