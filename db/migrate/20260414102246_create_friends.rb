class CreateFriends < ActiveRecord::Migration[8.1]
  def change
      create_table :friends, id: :uuid do |t|
        t.references :user, null: false, foreign_key: true, type: :uuid
        t.references :friend_user, null: false, foreign_key: { to_table: :users }, type: :uuid
        t.datetime :deleted_at, index: true
  
        t.timestamps
      end
  end
end
