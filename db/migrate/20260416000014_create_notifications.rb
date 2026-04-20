class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications, id: :uuid  do |t|
      t.uuid    :user_id,            null: false
      t.uuid    :actor_id                          # who triggered it (nullable)
      # notification_type: 0:new_message 1:friend_request 2:mention 3:reaction 4:group_invite
      t.integer :notification_type,  null: false
      t.string  :notifiable_type                    # polymorphic target
      t.uuid    :notifiable_id
      t.text    :body
      t.boolean :read,               default: false
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, [:user_id, :read],              name: "index_notifications_on_user_read"
    add_index :notifications, [:notifiable_type, :notifiable_id], name: "index_notifications_on_notifiable"
    add_index :notifications, :created_at
  end
end
