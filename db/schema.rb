# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_23_220604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
