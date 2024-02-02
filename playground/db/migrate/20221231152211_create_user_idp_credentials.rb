# frozen_string_literal: true

class CreateUserIdentityProviderCredentials < ActiveRecord::Migration[6.1]
  def change
    create_table :user_identity_provider_credentials do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :attribute_name, null: false
      t.string :provider, null: false
      t.string :token, null: false
      t.string :metadata, null: false

      t.timestamps

      t.index %i[user_id attribute_name]
    end
    add_index :user_identity_provider_credentials, %i[provider token], unique: true
    add_index :user_identity_provider_credentials, %i[user_id provider token], unique: true
  end
end
