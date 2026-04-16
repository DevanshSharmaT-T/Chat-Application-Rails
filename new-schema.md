```Ruby
ActiveRecord::Schema[8.1].define(version: 2026_04_16_000001) do
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  # ─── USERS ────────────────────────────────────────────────────────────────
  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    # Devise
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    # Profile
    t.string   "first_name",   null: false
    t.string   "last_name",    null: false
    t.string   "middle_name"
    t.string   "username",     null: false          # unique @handle
    t.string   "avatar_url"
    t.text     "bio"
    t.text     "status"                             # custom status message
    t.integer  "role",         default: 0
    # Presence — 0:offline 1:online 2:away 3:busy
    t.integer  "online_status",  default: 0
    t.datetime "last_seen_at"
    # Personalisation
    t.jsonb    "notification_preferences", default: {}
    t.string   "locale",     default: "en"
    t.string   "timezone"
    # Soft delete
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false

    t.index ["email"],               unique: true
    t.index ["username"],            unique: true
    t.index ["reset_password_token", unique: true
    t.index ["last_seen_at"]
    t.index ["deleted_at"]
  end

  # ─── DEVICE TOKENS (push notifications) ───────────────────────────────────
  # platform — 0:ios 1:android 2:web
  create_table "device_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "user_id",     null: false
    t.string   "token",       null: false
    t.integer  "platform",    null: false
    t.string   "device_name"
    t.datetime "last_used_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false

    t.index ["token"], unique: true
    t.index ["user_id"]
  end

  # ─── FRIENDSHIPS ──────────────────────────────────────────────────────────
  # status — 0:pending 1:accepted 2:declined 3:blocked
  create_table "friendships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "requester_id", null: false
    t.uuid     "addressee_id", null: false
    t.integer  "status",       default: 0
    t.datetime "accepted_at"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false

    t.index ["requester_id", "addressee_id"], unique: true, where: "deleted_at IS NULL"
    t.index ["addressee_id"]
    t.index ["deleted_at"]
  end

  # ─── BLOCKED USERS ────────────────────────────────────────────────────────
  create_table "blocked_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "blocker_id", null: false
    t.uuid     "blocked_id", null: false
    t.datetime "created_at", null: false

    t.index ["blocker_id", "blocked_id"], unique: true
    t.index ["blocked_id"]
  end

  # ─── GROUPS ───────────────────────────────────────────────────────────────
  # group_type — 0:private 1:public 2:broadcast
  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string   "name",          null: false
    t.text     "description"
    t.string   "avatar_url"
    t.uuid     "created_by_id", null: false
    t.integer  "group_type",    default: 0
    t.integer  "max_members",   default: 256
    t.string   "invite_code"
    t.datetime "deleted_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false

    t.index ["created_by_id"]
    t.index ["invite_code"], unique: true, where: "invite_code IS NOT NULL"
    t.index ["deleted_at"]
  end

  # ─── GROUP MEMBERS ────────────────────────────────────────────────────────
  # role — 0:member 1:moderator 2:admin 3:owner
  create_table "group_members", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "group_id",     null: false
    t.uuid     "user_id",      null: false
    t.integer  "role",         default: 0
    t.uuid     "invited_by_id"
    t.datetime "joined_at"
    t.boolean  "is_muted",     default: false
    t.datetime "muted_until"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false

    t.index ["group_id", "user_id"], unique: true, where: "deleted_at IS NULL"
    t.index ["user_id"]
    t.index ["deleted_at"]
  end

  # ─── CHATS ────────────────────────────────────────────────────────────────
  # chat_type — 0:direct 1:group 2:broadcast
  # chatable polymorphic → Friendship (DM) or Group
  create_table "chats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string   "chat_name"
    t.text     "description"
    t.integer  "chat_type",       default: 0
    t.uuid     "chatable_id",     null: false
    t.string   "chatable_type",   null: false
    t.uuid     "last_message_id"                # preview in conversation list
    t.datetime "last_activity_at"               # sort order for inbox
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false

    t.index ["chatable_type", "chatable_id"]
    t.index ["last_activity_at"]
    t.index ["deleted_at"]
  end

  # ─── CHAT PARTICIPANTS ────────────────────────────────────────────────────
  # Per-user settings for a chat (unread count, mute, pin, archive)
  create_table "chat_participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "chat_id",              null: false
    t.uuid     "user_id",              null: false
    t.uuid     "last_read_message_id"              # drives unread badge count
    t.datetime "last_read_at"
    t.boolean  "is_muted",             default: false
    t.datetime "muted_until"
    t.boolean  "is_pinned",            default: false
    t.boolean  "is_archived",          default: false
    t.datetime "archived_at"
    t.string   "custom_nickname"                   # rename a contact per chat
    t.datetime "deleted_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false

    t.index ["chat_id", "user_id"], unique: true, where: "deleted_at IS NULL"
    t.index ["user_id"]
    t.index ["deleted_at"]
  end

  # ─── MESSAGES ─────────────────────────────────────────────────────────────
  # message_type — 0:text 1:image 2:video 3:audio 4:file 5:system 6:sticker
  # status        — 0:sent 1:delivered 2:read (used on DMs only)
  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "chat_id",            null: false
    t.uuid     "user_id",            null: false
    t.text     "body"                              # nullable for attachment-only msgs
    t.integer  "message_type",       default: 0
    t.uuid     "reply_to_id"                       # threading
    t.uuid     "forwarded_from_id"                 # forward chain
    t.boolean  "is_edited",          default: false
    t.datetime "edited_at"
    t.integer  "status",             default: 0
    t.jsonb    "metadata",           default: {}   # link previews, giphy, polls, etc.
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false

    t.index ["chat_id", "created_at"]             # paginated message fetch
    t.index ["user_id"]
    t.index ["reply_to_id"]
    t.index ["deleted_at"]
  end

  # ─── MESSAGE RECEIPTS ─────────────────────────────────────────────────────
  # Per-user delivered/read tracking (double-tick system)
  create_table "message_receipts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "message_id",  null: false
    t.uuid     "user_id",     null: false
    t.datetime "delivered_at"
    t.datetime "read_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false

    t.index ["message_id", "user_id"], unique: true
    t.index ["user_id"]
  end

  # ─── MESSAGE REACTIONS ────────────────────────────────────────────────────
  create_table "message_reactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "message_id", null: false
    t.uuid     "user_id",    null: false
    t.string   "emoji",      null: false           # raw emoji char or shortcode
    t.datetime "created_at", null: false

    t.index ["message_id", "user_id", "emoji"], unique: true
    t.index ["user_id"]
  end

  # ─── ATTACHMENTS ──────────────────────────────────────────────────────────
  # attachment_type — 0:image 1:video 2:audio 3:document 4:sticker
  create_table "attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "message_id",      null: false
    t.string   "file_url",        null: false
    t.string   "file_name"
    t.string   "content_type"
    t.bigint   "file_size"                         # bytes
    t.integer  "attachment_type", default: 0
    t.integer  "width"                             # px (images / videos)
    t.integer  "height"                            # px
    t.integer  "duration_seconds"                  # audio / video
    t.string   "thumbnail_url"                     # video poster frame
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false

    t.index ["message_id"]
  end

  # ─── PINNED MESSAGES ──────────────────────────────────────────────────────
  create_table "pinned_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "chat_id",      null: false
    t.uuid     "message_id",   null: false
    t.uuid     "pinned_by_id", null: false
    t.datetime "created_at",   null: false

    t.index ["chat_id", "message_id"], unique: true
    t.index ["message_id"]
  end

  # ─── NOTIFICATIONS ────────────────────────────────────────────────────────
  # notification_type — 0:new_message 1:friend_request 2:mention 3:reaction 4:group_invite
  # notifiable polymorphic → Message, Friendship, Group, etc.
  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid     "user_id",           null: false
    t.uuid     "actor_id"                         # who triggered it
    t.integer  "notification_type", null: false
    t.string   "notifiable_type"
    t.uuid     "notifiable_id"
    t.text     "body"
    t.boolean  "read",              default: false
    t.datetime "read_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false

    t.index ["user_id", "read"]
    t.index ["notifiable_type", "notifiable_id"]
    t.index ["created_at"]
  end

  # ─── FOREIGN KEYS ─────────────────────────────────────────────────────────
  add_foreign_key "device_tokens",     "users"
  add_foreign_key "friendships",       "users", column: "requester_id"
  add_foreign_key "friendships",       "users", column: "addressee_id"
  add_foreign_key "blocked_users",     "users", column: "blocker_id"
  add_foreign_key "blocked_users",     "users", column: "blocked_id"
  add_foreign_key "groups",            "users", column: "created_by_id"
  add_foreign_key "group_members",     "groups"
  add_foreign_key "group_members",     "users"
  add_foreign_key "chats",             "messages", column: "last_message_id"
  add_foreign_key "chat_participants", "chats"
  add_foreign_key "chat_participants", "users"
  add_foreign_key "messages",          "chats"
  add_foreign_key "messages",          "users"
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
```

- use this as a reference and we will work on this.

## Points 

- `chat_participants` is the most important new table — it replaces guessing who's in a chat from the polymorphic `chatable` side and gives every user their own mute/pin/archive/unread state per conversation.

- `message_receipts` is separate from `messages.status` intentionally — `status` on the message itself (sent/delivered/read) is a fast shortcut for DMs, while `message_receipts` gives you per-user granularity in group chats (e.g. "seen by 12 of 20 members").

- `metadata jsonb` on messages is a pressure valve — link previews, poll payloads, location data, and giphy metadata can all live there without requiring new columns every time you add a message feature.

- The `composite unique index with WHERE deleted_at IS NULL` on `friendships` and `group_members` prevents duplicates while still allowing soft-delete history to coexist.

