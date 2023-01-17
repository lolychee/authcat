# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      # t.datetime :expired_at

      t.timestamps
    end
  end
end
