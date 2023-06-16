# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    enable_extension :hstore

    create_table :users do |t|
      t.string :email, null: false
      t.string :password
      t.string :one_time_password
      t.string :recovery_code
      t.string :recovery_codes

      t.string :polymorphic_password
      t.string :polymorphic_password_type

      t.timestamps null: false
    end
  end
end
