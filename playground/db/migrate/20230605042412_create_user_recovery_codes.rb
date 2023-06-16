# frozen_string_literal: true

class CreateUserRecoveryCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :user_recovery_codes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :password, null: false

      t.timestamps

      # t.index %i[user_id]
    end
  end
end
