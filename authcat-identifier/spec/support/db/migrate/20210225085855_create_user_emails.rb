# frozen_string_literal: true

class CreateUserEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :user_emails do |t|
      t.references :user, null: false, foreign_key: true, index: true

      t.string :identifier, null: false

      t.timestamps

      t.index %i[user_id identifier], unique: true
    end
  end
end
