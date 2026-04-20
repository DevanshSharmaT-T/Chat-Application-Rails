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
require "test_helper"

class GroupMemberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
