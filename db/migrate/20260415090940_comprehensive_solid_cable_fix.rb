class ComprehensiveSolidCableFix < ActiveRecord::Migration[8.1]
  def change
    # 1. CREATE SOLID CABLE TABLE IN PRIMARY DB
    # We do this manually to ensure it exists where Solid Cable looks
    unless table_exists?(:solid_cable_messages)
      create_table :solid_cable_messages do |t|
        t.text :channel, null: false
        t.text :payload, null: false
        t.datetime :created_at, null: false

        t.index :channel
        t.index :created_at
      end
    end

    # 2. FIX ACTIONCABLE (SOLID CABLE) INDEX BUG
    # Solid Cable needs an explicit unique index on 'id' for PG upserts
    add_index :solid_cable_messages, :id, unique: true, if_not_exists: true

    # 3. FIX MESSAGES TABLE INDEX (acts_as_paranoid conflict)
    if index_exists?(:messages, name: "index_messages_on_id_unique_active")
      remove_index :messages, name: "index_messages_on_id_unique_active"
    end
    
    # Standard unique index that Rails 8 can actually see
    add_index :messages, :id, unique: true, if_not_exists: true
  end
end