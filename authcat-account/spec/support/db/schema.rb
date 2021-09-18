# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_210_531_165_022) do
  create_table "sessions", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_ciphertext"
    t.string "email_bidx"
    t.string "phone_number_ciphertext"
    t.string "phone_number_bidx"
    t.string "password"
    t.string "one_time_password"
    t.string "recovery_codes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_bidx"], name: "index_users_on_email_bidx", unique: true
    t.index ["phone_number_bidx"], name: "index_users_on_phone_number_bidx", unique: true
  end
end
