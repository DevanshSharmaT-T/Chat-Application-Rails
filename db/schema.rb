# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_16_000015) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "attachment_type", default: 0
    t.string "content_type"
    t.datetime "created_at", null: false
    t.integer "duration_seconds"
    t.string "file_name"
    t.bigint "file_size"
    t.string "file_url", null: false
    t.integer "height"
    t.uuid "message_id", null: false
    t.string "thumbnail_url"
    t.datetime "updated_at", null: false
    t.integer "width"
    t.index ["message_id"], name: "index_attachments_on_message_id"
  end

  create_table "blocked_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blocked_id", null: false
    t.uuid "blocker_id", null: false
    t.datetime "created_at", null: false
    t.index ["blocked_id"], name: "index_blocked_users_on_blocked_id"
    t.index ["blocker_id", "blocked_id"], name: "index_blocked_users_on_blocker_id_and_blocked_id", unique: true
  end

  create_table "chat_participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "archived_at"
    t.uuid "chat_id", null: false
    t.datetime "created_at", null: false
    t.string "custom_nickname"
    t.datetime "deleted_at"
    t.boolean "is_archived", default: false
    t.boolean "is_muted", default: false
    t.boolean "is_pinned", default: false
    t.datetime "last_read_at"
    t.uuid "last_read_message_id"
    t.datetime "muted_until"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["chat_id", "user_id"], name: "index_chat_participants_on_chat_user_active", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_chat_participants_on_deleted_at"
    t.index ["user_id"], name: "index_chat_participants_on_user_id"
  end

  create_table "chats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "chat_name"
    t.integer "chat_type", default: 0
    t.uuid "chatable_id", null: false
    t.string "chatable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.datetime "last_activity_at"
    t.uuid "last_message_id"
    t.datetime "updated_at", null: false
    t.index ["chatable_type", "chatable_id"], name: "index_chats_on_chatable"
    t.index ["deleted_at"], name: "index_chats_on_deleted_at"
    t.index ["last_activity_at"], name: "index_chats_on_last_activity_at"
  end

  create_table "device_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "device_name"
    t.datetime "last_used_at"
    t.integer "platform", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["token"], name: "index_device_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_device_tokens_on_user_id"
  end

  create_table "friendships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "accepted_at"
    t.uuid "addressee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.uuid "requester_id", null: false
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["addressee_id"], name: "index_friendships_on_addressee_id"
    t.index ["deleted_at"], name: "index_friendships_on_deleted_at"
    t.index ["requester_id", "addressee_id"], name: "index_friendships_on_requester_addressee_active", unique: true, where: "(deleted_at IS NULL)"
    t.index ["requester_id"], name: "index_friendships_on_requester_id"
  end

  create_table "group_members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.uuid "group_id", null: false
    t.uuid "invited_by_id"
    t.boolean "is_muted", default: false
    t.datetime "joined_at"
    t.datetime "muted_until"
    t.integer "role", default: 0
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["deleted_at"], name: "index_group_members_on_deleted_at"
    t.index ["group_id", "user_id"], name: "index_group_members_on_group_user_active", unique: true, where: "(deleted_at IS NULL)"
    t.index ["group_id"], name: "index_group_members_on_group_id"
    t.index ["invited_by_id"], name: "index_group_members_on_invited_by_id"
    t.index ["user_id"], name: "index_group_members_on_user_id"
  end

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.uuid "created_by_id", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.integer "group_type", default: 0
    t.string "invite_code"
    t.integer "max_members", default: 256
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_groups_on_created_by_id"
    t.index ["deleted_at"], name: "index_groups_on_deleted_at"
    t.index ["invite_code"], name: "index_groups_on_invite_code_unique_not_null", unique: true, where: "(invite_code IS NOT NULL)"
  end

  create_table "message_reactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "emoji", null: false
    t.uuid "message_id", null: false
    t.uuid "user_id", null: false
    t.index ["message_id", "user_id", "emoji"], name: "index_message_reactions_on_message_user_emoji", unique: true
    t.index ["user_id"], name: "index_message_reactions_on_user_id"
  end

  create_table "message_receipts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "delivered_at"
    t.uuid "message_id", null: false
    t.datetime "read_at"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["message_id", "user_id"], name: "index_message_receipts_on_message_user", unique: true
    t.index ["user_id"], name: "index_message_receipts_on_user_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "body"
    t.uuid "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.datetime "edited_at"
    t.uuid "forwarded_from_id"
    t.boolean "is_edited", default: false
    t.integer "message_type", default: 0
    t.jsonb "metadata", default: {}
    t.uuid "reply_to_id"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["chat_id", "created_at"], name: "index_messages_on_chat_id_created_at"
    t.index ["deleted_at"], name: "index_messages_on_deleted_at"
    t.index ["metadata"], name: "index_messages_on_metadata_gin", using: :gin
    t.index ["reply_to_id"], name: "index_messages_on_reply_to_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "actor_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.uuid "notifiable_id"
    t.string "notifiable_type"
    t.integer "notification_type", null: false
    t.boolean "read", default: false
    t.datetime "read_at"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["created_at"], name: "index_notifications_on_created_at"
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id", "read"], name: "index_notifications_on_user_read"
  end

  create_table "pinned_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "chat_id", null: false
    t.datetime "created_at", null: false
    t.uuid "message_id", null: false
    t.uuid "pinned_by_id", null: false
    t.index ["chat_id", "message_id"], name: "index_pinned_messages_on_chat_message", unique: true
    t.index ["message_id"], name: "index_pinned_messages_on_message_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "avatar_url"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "last_seen_at"
    t.string "locale", default: "en"
    t.datetime "locked_at"
    t.string "middle_name"
    t.jsonb "notification_preferences", default: {}
    t.integer "online_status", default: 0
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0
    t.text "status"
    t.string "timezone"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_seen_at"], name: "index_users_on_last_seen_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "attachments", "messages"
  add_foreign_key "blocked_users", "users", column: "blocked_id"
  add_foreign_key "blocked_users", "users", column: "blocker_id"
  add_foreign_key "chat_participants", "chats"
  add_foreign_key "chat_participants", "users"
  add_foreign_key "chats", "messages", column: "last_message_id"
  add_foreign_key "device_tokens", "users"
  add_foreign_key "friendships", "users", column: "addressee_id"
  add_foreign_key "friendships", "users", column: "requester_id"
  add_foreign_key "group_members", "groups"
  add_foreign_key "group_members", "users"
  add_foreign_key "groups", "users", column: "created_by_id"
  add_foreign_key "message_reactions", "messages"
  add_foreign_key "message_reactions", "users"
  add_foreign_key "message_receipts", "messages"
  add_foreign_key "message_receipts", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "messages", column: "forwarded_from_id"
  add_foreign_key "messages", "messages", column: "reply_to_id"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "actor_id"
  add_foreign_key "pinned_messages", "chats"
  add_foreign_key "pinned_messages", "messages"
  add_foreign_key "pinned_messages", "users", column: "pinned_by_id"
end
