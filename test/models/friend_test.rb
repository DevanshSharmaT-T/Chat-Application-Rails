# == Schema Information
#
# Table name: friends
#
#  id             :uuid             not null, primary key
#  deleted_at     :datetime
#  status         :integer          default("pending")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  friend_user_id :uuid             not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_friends_on_deleted_at      (deleted_at)
#  index_friends_on_friend_user_id  (friend_user_id)
#  index_friends_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (friend_user_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class FriendTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
