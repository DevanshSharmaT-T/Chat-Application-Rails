# == Schema Information
#
# Table name: blocked_users
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  blocked_id :uuid             not null
#  blocker_id :uuid             not null
#
# Indexes
#
#  index_blocked_users_on_blocked_id                 (blocked_id)
#  index_blocked_users_on_blocker_id_and_blocked_id  (blocker_id,blocked_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (blocked_id => users.id)
#  fk_rails_...  (blocker_id => users.id)
#
class BlockedUser < ApplicationRecord
  belongs_to :blocker, class_name: "User"
  belongs_to :blocked, class_name: "User"

  validates :blocker_id, uniqueness: { scope: :blocked_id }
end
