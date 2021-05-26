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

ActiveRecord::Schema.define(version: 2021_02_25_085855) do

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_ciphertext"
    t.string "email_bidx"
    t.string "phone_number_ciphertext"
    t.string "phone_number_bidx"
    t.string "password_digest"
    t.string "one_time_password_secret"
    t.datetime "one_time_password_last_used_at"
    t.string "recovery_codes_digest"
    t.string "github_oauth_token"
    t.string "google_oauth_token"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email_bidx"], name: "index_users_on_email_bidx", unique: true
    t.index ["phone_number_bidx"], name: "index_users_on_phone_number_bidx", unique: true
  end

  add_foreign_key "sessions", "users"
end
