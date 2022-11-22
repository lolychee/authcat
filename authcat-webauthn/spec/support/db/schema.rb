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

ActiveRecord::Schema.define(version: 2022_11_22_100916) do

  create_table "user_webauthn_credentials", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "webauthn_id", null: false
    t.string "name", null: false
    t.string "public_key", null: false
    t.integer "sign_count", null: false
    t.string "challenge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "webauthn_id"], name: "index_user_webauthn_credentials_on_user_id_and_webauthn_id", unique: true
    t.index ["user_id"], name: "index_user_webauthn_credentials_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "webauthn_user_id"
    t.string "webauthn_challenge"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "user_webauthn_credentials", "users"
end
