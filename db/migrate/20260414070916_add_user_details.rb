class AddUserDetails < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :first_name, :string, null: false
    add_column :users, :last_name, :string, null: false
    add_column :users, :middle_name, :string
    add_column :users, :role, :integer, default: 0
    add_column :users, :status, :text
    add_column :users, :deleted_at, :datetime, default: nil
  end
end
