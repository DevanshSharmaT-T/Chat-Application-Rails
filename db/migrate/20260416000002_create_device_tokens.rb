class CreateDeviceTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :device_tokens, id: :uuid do |t|
      t.uuid    :user_id,     null: false
      t.string  :token,       null: false
      # platform: 0:ios 1:android 2:web
      t.integer :platform,    null: false
      t.string  :device_name
      t.datetime :last_used_at

      t.timestamps
    end

    add_index :device_tokens, :token,   unique: true
    add_index :device_tokens, :user_id
  end
end
