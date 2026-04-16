# == Schema Information
#
# Table name: pinned_messages
#
#  id           :uuid             not null, primary key
#  created_at   :datetime         not null
#  chat_id      :uuid             not null
#  message_id   :uuid             not null
#  pinned_by_id :uuid             not null
#
# Indexes
#
#  index_pinned_messages_on_chat_message  (chat_id,message_id) UNIQUE
#  index_pinned_messages_on_message_id    (message_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (message_id => messages.id)
#  fk_rails_...  (pinned_by_id => users.id)
#
class PinnedMessage < ApplicationRecord
  belongs_to :chat
  belongs_to :message
  belongs_to :pinned_by, class_name: "User"

  validates :message_id, uniqueness: { scope: :chat_id }
end
