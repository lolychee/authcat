# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension :hstore

    create_table :users do |t|
      t.string :email, index: { unique: true }

      # t.string :email_ciphertext
      # t.string :email_bidx, index: { unique: true }

      t.string :phone_number, index: { unique: true }

      # t.string :phone_number_ciphertext
      # t.string :phone_number_bidx, index: { unique: true }

      t.string :password

      t.timestamps null: false
    end
  end
end
