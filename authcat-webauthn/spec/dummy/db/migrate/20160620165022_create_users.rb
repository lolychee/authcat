# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name

      t.string :email, null: false
      t.string :password

      t.string :webauthn_user_id
      t.string :webauthn_challenge

      t.timestamps null: false
    end
  end
end
