# == Schema Information
#
# Table name: notifications
#
#  id                :uuid             not null, primary key
#  body              :text
#  notifiable_type   :string
#  notification_type :integer          not null
#  read              :boolean          default(FALSE)
#  read_at           :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  actor_id          :uuid
#  notifiable_id     :uuid
#  user_id           :uuid             not null
#
# Indexes
#
#  index_notifications_on_created_at  (created_at)
#  index_notifications_on_notifiable  (notifiable_type,notifiable_id)
#  index_notifications_on_user_read   (user_id,read)
#
# Foreign Keys
#
#  fk_rails_...  (actor_id => users.id)
#  fk_rails_...  (user_id => users.id)
#
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: "User", optional: true
  belongs_to :notifiable, polymorphic: true

  enum :notification_type, { new_message: 0, friend_request: 1, mention: 2, reaction: 3, group_invite: 4 }
end
