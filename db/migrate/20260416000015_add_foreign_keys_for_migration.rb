class AddForeignKeysForMigration < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key "device_tokens",     "users"
    # add_foreign_key "friendships",       "users", column: "requester_id"
    # add_foreign_key "friendships",       "users", column: "addressee_id"
    add_foreign_key "blocked_users",     "users", column: "blocker_id"
    add_foreign_key "blocked_users",     "users", column: "blocked_id"
    
    # groups already had foreign key to users, but column renamed to created_by_id. 
    # Must remove old fk first if we do this cleanly, but since we renamed column, 
    # rails might have preserved or broken it. We ensure correct one.
    remove_foreign_key "groups", "users", if_exists: true
    add_foreign_key "groups",            "users", column: "created_by_id"
    
    # group_members
    # remove_foreign_key "group_members", "groups", if_exists: true
    # remove_foreign_key "group_members", "users", if_exists: true
    # add_foreign_key "group_members",     "groups"
    # add_foreign_key "group_members",     "users"
    
    # chats had no FKs in original schema (only polymorphic chatable index)
    add_foreign_key "chats",             "messages", column: "last_message_id"
    
    add_foreign_key "chat_participants", "chats"
    add_foreign_key "chat_participants", "users"
    
    # messages already had chat_id and user_id fks
    add_foreign_key "messages",          "messages", column: "reply_to_id"
    add_foreign_key "messages",          "messages", column: "forwarded_from_id"
    
    add_foreign_key "message_receipts",  "messages"
    add_foreign_key "message_receipts",  "users"
    
    add_foreign_key "message_reactions", "messages"
    add_foreign_key "message_reactions", "users"
    
    add_foreign_key "attachments",       "messages"
    
    add_foreign_key "pinned_messages",   "chats"
    add_foreign_key "pinned_messages",   "messages"
    add_foreign_key "pinned_messages",   "users", column: "pinned_by_id"
    
    add_foreign_key "notifications",     "users"
    add_foreign_key "notifications",     "users", column: "actor_id"
  end
end
