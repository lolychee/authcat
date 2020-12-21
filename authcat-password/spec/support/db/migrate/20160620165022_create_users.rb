# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension :hstore

    create_table :users do |t|
      t.string :email,            null: false
      t.string :password_digest,  null: false

      t.timestamps null: false
    end
  end
end
