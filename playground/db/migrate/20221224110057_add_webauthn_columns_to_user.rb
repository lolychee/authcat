class AddWebAuthnColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :webauthn_user_id, :string
    add_column :users, :webauthn_challenge, :string
  end
end
