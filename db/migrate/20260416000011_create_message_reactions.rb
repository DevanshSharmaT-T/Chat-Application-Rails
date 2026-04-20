class CreateMessageReactions < ActiveRecord::Migration[8.1]
  def change
    create_table :message_reactions, id: :uuid do |t|
      t.uuid   :message_id, null: false
      t.uuid   :user_id,    null: false
      t.string :emoji,      null: false   # raw emoji char or shortcode

      t.datetime :created_at, null: false
    end

    # One emoji reaction per user per message
    add_index :message_reactions, [:message_id, :user_id, :emoji], unique: true,
              name: "index_message_reactions_on_message_user_emoji"
    add_index :message_reactions, :user_id
  end
end
