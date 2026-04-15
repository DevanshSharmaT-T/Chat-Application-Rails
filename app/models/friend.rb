# == Schema Information
#
# Table name: friends
#
#  id             :uuid             not null, primary key
#  deleted_at     :datetime
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
class Friend < ApplicationRecord

  acts_as_paranoid

  belongs_to :user
  belongs_to :friend_user, class_name: "User"
  has_one :chat, as: :chatable, dependent: :destroy

  after_create :create_dm


end
