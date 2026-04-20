class UpgradeChats < ActiveRecord::Migration[8.1]
  def change
    # chat_type: 0:direct_message 1:group_chat 2:broadcast_group
    add_column :chats, :chat_type,        :integer, default: 0
    add_column :chats, :last_message_id,  :uuid
    add_column :chats, :last_activity_at, :datetime

    add_index :chats, :last_activity_at
  end
end
