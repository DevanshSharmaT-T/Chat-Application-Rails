class EnablePgcryptoAndUpgradeUsers < ActiveRecord::Migration[8.1]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    # Add new profile columns
    add_column :users, :username,                  :string
    add_column :users, :avatar_url,                :string
    add_column :users, :bio,                       :text
    # online_status: 0:offline 1:online 2:away 3:busy
    add_column :users, :online_status,             :integer, default: 0
    add_column :users, :last_seen_at,              :datetime
    add_column :users, :notification_preferences,  :jsonb,   default: {}
    add_column :users, :locale,                    :string,  default: "en"
    add_column :users, :timezone,                  :string

    # Indexes
    add_index :users, :username,     unique: true
    add_index :users, :last_seen_at
    add_index :users, :deleted_at
  end
end
