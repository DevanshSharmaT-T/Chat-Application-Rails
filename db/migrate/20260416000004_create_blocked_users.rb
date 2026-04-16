class CreateBlockedUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :blocked_users, id: :uuid do |t|
      t.uuid :blocker_id, null: false
      t.uuid :blocked_id, null: false

      t.datetime :created_at, null: false
    end

    add_index :blocked_users, [:blocker_id, :blocked_id], unique: true
    add_index :blocked_users, :blocked_id
  end
end
