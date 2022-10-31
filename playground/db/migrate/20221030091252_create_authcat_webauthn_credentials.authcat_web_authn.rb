# frozen_string_literal: true
# This migration comes from authcat:webauthn (originally 20221014165022)

class CreateAuthcatWebauthnCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :authcat_webauthn_credentials, id: :string, primary_key: :webauthn_id do |t|
      t.references :identity, null: false, polymorphic: true, index: false
      t.string :name, null: false
      t.string :public_key, null: false, unique: true
      t.integer :sign_count, null: false

      t.timestamps null: false

      t.index %i[identity_type identity_id webauthn_id], name: "index_authcat_webauthn_credentials_uniqueness",
                                                         unique: true
    end
  end
end
