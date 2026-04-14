class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages, id: :uuid do |t|
          t.text :body, null: false
          t.references :user, null: false, foreign_key: true, type: :uuid
          t.references :chat, null: false, foreign_key: true, type: :uuid
          t.datetime :deleted_at, index: true
    
          t.timestamps
    end
  end
end
