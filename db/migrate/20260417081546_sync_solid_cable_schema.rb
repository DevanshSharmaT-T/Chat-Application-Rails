class SyncSolidCableSchema < ActiveRecord::Migration[8.1]
  def change
    # 1. Drop the incomplete table we created manually
    drop_table :solid_cable_messages, if_exists: true

    # 2. Recreate it with the exact Rails 8.1.3 / Solid Cable 1.0+ requirements
    create_table :solid_cable_messages do |t|
      t.binary :channel, null: false
      t.binary :payload, null: false
      t.integer :channel_hash, limit: 8, null: false # This was the missing 'channel_hash'
      t.datetime :created_at, null: false

      # Indexes for performance
      t.index [ :channel_hash, :id ], name: "index_solid_cable_messages_on_channel_hash_and_id"
      t.index :created_at, name: "index_solid_cable_messages_on_created_at"
      
      # THE CRITICAL FIX: Explicit unique index on id for Postgres UPSERT
      t.index :id, unique: true
    end
  end
end