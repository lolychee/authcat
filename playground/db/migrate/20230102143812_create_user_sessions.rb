# frozen_string_literal: true

class CreateUserSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_sessions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name
      t.string :state, null: false

      t.timestamps

      t.index %i[user_id name]
    end
    # add_index :user_sessions, [:user_id, :device_type]
  end
end
