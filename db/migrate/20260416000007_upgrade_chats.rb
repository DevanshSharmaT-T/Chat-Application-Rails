class UpgradeChats < ActiveRecord::Migration[8.1]
  def change
    # chat_type: 0:direct 1:group 2:broadcast
    add_column :chats, :chat_type,        :integer, default: 0
    add_column :chats, :last_message_id,  :uuid
    add_column :chats, :last_activity_at, :datetime

    add_index :chats, :last_activity_at
  end
end
