# == Schema Information
#
# Table name: friends
#
#  id             :uuid             not null, primary key
#  deleted_at     :datetime
#  status         :integer          default(0)
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

  enum :status, { pending: 0, accepted: 1 }

  belongs_to :user
  belongs_to :friend_user, class_name: "User"
  has_one :chat, as: :chatable, dependent: :destroy

  after_create :create_dm

  private

  def create_dm
    create_chat!(chat_name: "#{user.full_name} & #{friend_user.full_name}")
  end

end
