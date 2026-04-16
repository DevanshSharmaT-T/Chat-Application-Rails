class CreateMessageReceipts < ActiveRecord::Migration[8.1]
  def change
    create_table :message_receipts, id: :uuid do |t|
      t.uuid     :message_id, null: false
      t.uuid     :user_id,    null: false
      t.datetime :delivered_at
      t.datetime :read_at

      t.timestamps
    end

    # One receipt row per user per message
    add_index :message_receipts, [:message_id, :user_id], unique: true,
              name: "index_message_receipts_on_message_user"
    add_index :message_receipts, :user_id
  end
end
