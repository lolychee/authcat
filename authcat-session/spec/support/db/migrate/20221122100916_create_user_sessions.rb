# frozen_string_literal: true

class CreateUserSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_sessions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :token, null: false

      t.timestamps

      t.index %i[user_id name]
    end
  end
end
