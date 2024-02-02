# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.references :user
      t.string :token, index: { unique: true }

      t.timestamps null: false
    end
  end
end
