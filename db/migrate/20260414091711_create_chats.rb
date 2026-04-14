class CreateChats < ActiveRecord::Migration[8.1]
  def change
    create_table :chats, id: :uuid do |t|
      t.string :chat_name
      t.text :description
      t.references :chatable, polymorphic: true, null: false, type: :uuid, index: true
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
