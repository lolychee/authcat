class CreateUserIdProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :user_id_providers do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :token, null: false
      t.string :metadata, null: false

      t.timestamps
    end
    add_index :user_id_providers, %i[provider user_id], unique: true
    add_index :user_id_providers, %i[provider token], unique: true
  end
end
