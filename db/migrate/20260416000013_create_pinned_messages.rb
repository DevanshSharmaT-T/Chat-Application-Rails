class CreatePinnedMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :pinned_messages, id: :uuid do |t|
      t.uuid :chat_id,      null: false
      t.uuid :message_id,   null: false
      t.uuid :pinned_by_id, null: false

      t.datetime :created_at, null: false
    end

    # Can only pin a message once per chat
    add_index :pinned_messages, [:chat_id, :message_id], unique: true,
              name: "index_pinned_messages_on_chat_message"
    add_index :pinned_messages, :message_id
  end
end
