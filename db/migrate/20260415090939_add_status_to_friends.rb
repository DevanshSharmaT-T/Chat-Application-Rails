class AddStatusToFriends < ActiveRecord::Migration[8.1]
  def change
    add_column :friends, :status, :integer, default: 0
  end
end
