class CreateChatParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :chat_participants, id: :uuid do |t|
      t.uuid     :chat_id,              null: false
      t.uuid     :user_id,              null: false
      t.uuid     :last_read_message_id                # drives unread badge count
      t.datetime :last_read_at
      t.boolean  :is_muted,             default: false
      t.datetime :muted_until
      t.boolean  :is_pinned,            default: false
      t.boolean  :is_archived,          default: false
      t.datetime :archived_at
      t.string   :custom_nickname                     # rename contact per chat
      t.datetime :deleted_at

      t.timestamps
    end

    # Only one active participant record per user per chat
    add_index :chat_participants, [:chat_id, :user_id],
              unique: true,
              where: "deleted_at IS NULL",
              name: "index_chat_participants_on_chat_user_active"
    add_index :chat_participants, :user_id
    add_index :chat_participants, :deleted_at
  end
end
