# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension :hstore

    create_table :users do |t|
      t.string :name
      t.string :email, null: false, index: { unique: true }
      # t.string :password,   null: false

      t.timestamps null: false
    end
  end
end
