# == Schema Information
#
# Table name: group_members
#
#  id            :uuid             not null, primary key
#  deleted_at    :datetime
#  is_muted      :boolean          default(FALSE)
#  joined_at     :datetime
#  muted_until   :datetime
#  role          :integer          default("member")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  group_id      :uuid             not null
#  invited_by_id :uuid
#  user_id       :uuid             not null
#
# Indexes
#
#  index_group_members_on_deleted_at         (deleted_at)
#  index_group_members_on_group_id           (group_id)
#  index_group_members_on_group_user_active  (group_id,user_id) UNIQUE WHERE (deleted_at IS NULL)
#  index_group_members_on_invited_by_id      (invited_by_id)
#  index_group_members_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#
class GroupMember < ApplicationRecord
  acts_as_paranoid

  belongs_to :group
  belongs_to :user
  belongs_to :invited_by, class_name: "User", optional: true

  enum :role, { member: 0, moderator: 1, admin: 2, owner: 3 }

  validates :user_id, uniqueness: { scope: :group_id, conditions: -> { where(deleted_at: nil) } }
end
