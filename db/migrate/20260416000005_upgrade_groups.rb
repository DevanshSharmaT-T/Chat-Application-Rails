class UpgradeGroups < ActiveRecord::Migration[8.1]
  def change
    # Rename owner column
    rename_column :groups, :user_id, :created_by_id

    # Add new columns
    add_column :groups, :avatar_url,  :string
    # group_type: 0:private 1:public 2:broadcast
    add_column :groups, :group_type,  :integer, default: 0
    add_column :groups, :max_members, :integer, default: 256
    add_column :groups, :invite_code, :string

    # (index_groups_on_user_id was automatically renamed to index_groups_on_created_by_id)
    add_index :groups, :invite_code,
              unique: true,
              where: "invite_code IS NOT NULL",
              name: "index_groups_on_invite_code_unique_not_null"
  end
end
