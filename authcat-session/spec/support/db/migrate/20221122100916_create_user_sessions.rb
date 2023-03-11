# frozen_string_literal: true

class CreateUserSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_sessions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :token, null: false
      t.string :name, null: false

      t.timestamps
    end
    # add_index :user_sessions, %i[user_id], unique: true
  end
end
