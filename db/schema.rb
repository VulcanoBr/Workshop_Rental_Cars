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

ActiveRecord::Schema[7.1].define(version: 2024_01_04_221261) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "number"
    t.string "complement"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.bigint "subsidiary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subsidiary_id"], name: "index_addresses_on_subsidiary_id"
  end

  create_table "car_models", force: :cascade do |t|
    t.string "name"
    t.string "year"
    t.bigint "manufacture_id"
    t.text "car_options"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manufacture_id"], name: "index_car_models_on_manufacture_id"
  end

  create_table "cars", force: :cascade do |t|
    t.bigint "car_model_id"
    t.string "color"
    t.string "license_plate"
    t.integer "car_km"
    t.bigint "subsidiary_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_model_id"], name: "index_cars_on_car_model_id"
    t.index ["subsidiary_id"], name: "index_cars_on_subsidiary_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "cpf"
    t.string "phone"
    t.string "type"
    t.string "cnpj"
    t.string "fantasy_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "fines", force: :cascade do |t|
    t.date "issued_on"
    t.integer "demerit_points"
    t.decimal "fine_value", precision: 12, scale: 2, default: "0.0"
    t.string "address"
    t.bigint "car_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_fines_on_car_id"
  end

  create_table "inspections", force: :cascade do |t|
    t.integer "fuel_level"
    t.integer "cleanance_level"
    t.text "damages"
    t.bigint "car_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_inspections_on_car_id"
    t.index ["user_id"], name: "index_inspections_on_user_id"
  end

  create_table "maintenances", force: :cascade do |t|
    t.bigint "car_id"
    t.bigint "provider_id"
    t.string "invoice"
    t.decimal "service_cost", precision: 12, scale: 2, default: "0.0"
    t.datetime "maintenance_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_maintenances_on_car_id"
    t.index ["provider_id"], name: "index_maintenances_on_provider_id"
  end

  create_table "manufactures", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rentals", force: :cascade do |t|
    t.bigint "car_id"
    t.bigint "user_id"
    t.bigint "customer_id"
    t.string "rented_code"
    t.decimal "daily_price", default: "0.0"
    t.datetime "start_at"
    t.datetime "finished_at"
    t.integer "status", default: 0
    t.date "scheduled_start"
    t.date "scheduled_end"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_rentals_on_car_id"
    t.index ["customer_id"], name: "index_rentals_on_customer_id"
    t.index ["user_id"], name: "index_rentals_on_user_id"
  end

  create_table "subsidiaries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subsidiary_car_models", force: :cascade do |t|
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.bigint "subsidiary_id"
    t.bigint "car_model_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_model_id"], name: "index_subsidiary_car_models_on_car_model_id"
    t.index ["subsidiary_id"], name: "index_subsidiary_car_models_on_subsidiary_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", precision: 12, scale: 2, default: "0.0"
    t.string "type"
    t.bigint "subsidiary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transactable_type"
    t.bigint "transactable_id"
    t.index ["subsidiary_id"], name: "index_transactions_on_subsidiary_id"
    t.index ["transactable_type", "transactable_id"], name: "index_transactions_on_transactable"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "subsidiary_id"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["subsidiary_id"], name: "index_users_on_subsidiary_id"
  end

  add_foreign_key "addresses", "subsidiaries"
  add_foreign_key "car_models", "manufactures"
  add_foreign_key "cars", "car_models"
  add_foreign_key "cars", "subsidiaries"
  add_foreign_key "fines", "cars"
  add_foreign_key "inspections", "cars"
  add_foreign_key "inspections", "users"
  add_foreign_key "maintenances", "cars"
  add_foreign_key "maintenances", "providers"
  add_foreign_key "rentals", "cars"
  add_foreign_key "rentals", "customers"
  add_foreign_key "rentals", "users"
  add_foreign_key "subsidiary_car_models", "car_models"
  add_foreign_key "subsidiary_car_models", "subsidiaries"
  add_foreign_key "transactions", "subsidiaries"
  add_foreign_key "users", "subsidiaries"
end
