class RenameFriendsToFriendshipsAndUpgrade < ActiveRecord::Migration[8.1]
  def change
    # Step 1: Rename the table
    rename_table :friends, :friendships

    # Step 2: Rename columns to match new schema
    rename_column :friendships, :user_id,        :requester_id
    rename_column :friendships, :friend_user_id, :addressee_id

    # Step 3: Add missing columns
    add_column :friendships, :accepted_at, :datetime

    # Step 4: Drop old weak indexes if they still exist under old names (unlikely but safe)
    remove_index :friendships, name: "index_friends_on_user_id",        if_exists: true
    remove_index :friendships, name: "index_friends_on_friend_user_id", if_exists: true
    remove_index :friendships, name: "index_friends_on_deleted_at",     if_exists: true

    # Step 5: Add new proper indexes
    # Composite unique — only enforce on non-deleted rows
    add_index :friendships, [:requester_id, :addressee_id],
              unique: true,
              where: "deleted_at IS NULL",
              name: "index_friendships_on_requester_addressee_active"
              
    # Note: indexes on requester_id, addressee_id, and deleted_at were already 
    # automatically renamed by Rails during rename_table/rename_column.
  end
end
