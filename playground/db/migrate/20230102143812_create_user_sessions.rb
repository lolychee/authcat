# frozen_string_literal: true

class CreateUserSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_sessions do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.string :state, null: false
      t.timestamps
    end
    # add_index :user_sessions, [:user_id, :device_type]
  end
end
