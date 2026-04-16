class UpgradeGroupMembers < ActiveRecord::Migration[8.1]
  def change
    # Add new columns
    # role: 0:member 1:moderator 2:admin 3:owner
    add_column :group_members, :role,         :integer, default: 0
    add_column :group_members, :invited_by_id, :uuid
    add_column :group_members, :joined_at,    :datetime
    add_column :group_members, :is_muted,     :boolean, default: false
    add_column :group_members, :muted_until,  :datetime

    # Add composite unique index — only enforce on active (non-deleted) rows
    add_index :group_members, [:group_id, :user_id],
              unique: true,
              where: "deleted_at IS NULL",
              name: "index_group_members_on_group_user_active"
    
    # index_group_members_on_user_id and group_id already exist from old schema
    add_index :group_members, :invited_by_id
  end
end
