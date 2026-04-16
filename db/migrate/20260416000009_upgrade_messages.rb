class UpgradeMessages < ActiveRecord::Migration[8.1]
  def change
    # body was NOT NULL — relax it (attachment-only messages have no text body)
    change_column_null :messages, :body, true

    # message_type: 0:text 1:image 2:video 3:audio 4:file 5:system 6:sticker
    add_column :messages, :message_type,      :integer,  default: 0
    add_column :messages, :reply_to_id,       :uuid                   # threading
    add_column :messages, :forwarded_from_id, :uuid                   # forward chain
    add_column :messages, :is_edited,         :boolean,  default: false
    add_column :messages, :edited_at,         :datetime
    # status: 0:sent 1:delivered 2:read (DM shortcut)
    add_column :messages, :status,            :integer,  default: 0
    add_column :messages, :metadata,          :jsonb,    default: {}  # link previews, polls, etc.

    # Replace plain chat_id index with composite for paginated message fetch
    remove_index :messages, name: "index_messages_on_chat_id", if_exists: true
    add_index :messages, [:chat_id, :created_at], name: "index_messages_on_chat_id_created_at"

    add_index :messages, :reply_to_id
    add_index :messages, :metadata, using: :gin, name: "index_messages_on_metadata_gin"
  end
end
