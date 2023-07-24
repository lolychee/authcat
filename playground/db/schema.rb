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

ActiveRecord::Schema[7.0].define(version: 2023_06_26_151640) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.integer "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "user_idp_credentials", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "attribute_name", null: false
    t.string "provider", null: false
    t.string "token", null: false
    t.string "metadata", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "token"], name: "index_user_idp_credentials_on_provider_and_token", unique: true
    t.index ["user_id", "attribute_name"], name: "index_user_idp_credentials_on_user_id_and_attribute_name"
    t.index ["user_id", "provider", "token"], name: "index_user_idp_credentials_on_user_id_and_provider_and_token", unique: true
    t.index ["user_id"], name: "index_user_idp_credentials_on_user_id"
  end

  create_table "user_passkeys", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "webauthn_id", null: false
    t.string "title", null: false
    t.string "public_key", null: false
    t.integer "sign_count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "webauthn_id"], name: "index_user_passkeys_on_user_id_and_webauthn_id", unique: true
    t.index ["user_id"], name: "index_user_passkeys_on_user_id"
  end

  create_table "user_recovery_codes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_recovery_codes_on_user_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.string "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_user_sessions_on_user_id_and_name"
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.string "password"
    t.string "one_time_password"
    t.string "recovery_codes"
    t.string "github_oauth_token"
    t.string "google_oauth_token"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "webauthn_id"
    t.string "webauthn_challenge"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "user_idp_credentials", "users"
  add_foreign_key "user_passkeys", "users"
  add_foreign_key "user_recovery_codes", "users"
  add_foreign_key "user_sessions", "users"
end
