# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_160_620_165_022) do
  create_table 'users', force: :cascade do |t|
    t.string 'email', null: false
    t.string 'otp_secret'
    t.datetime 'otp_last_used_at'
    t.string 'backup_codes_digest'
    t.string 'security_questions'
    t.string 'webauthn_id'
    t.string 'webauthn_public_key'
    t.integer 'webauthn_sign_count'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
