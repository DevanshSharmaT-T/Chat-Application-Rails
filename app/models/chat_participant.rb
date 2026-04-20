# == Schema Information
#
# Table name: chat_participants
#
#  id                   :uuid             not null, primary key
#  archived_at          :datetime
#  custom_nickname      :string
#  deleted_at           :datetime
#  is_archived          :boolean          default(FALSE)
#  is_muted             :boolean          default(FALSE)
#  is_pinned            :boolean          default(FALSE)
#  last_read_at         :datetime
#  muted_until          :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  chat_id              :uuid             not null
#  last_read_message_id :uuid
#  user_id              :uuid             not null
#
# Indexes
#
#  index_chat_participants_on_chat_user_active  (chat_id,user_id) UNIQUE WHERE (deleted_at IS NULL)
#  index_chat_participants_on_deleted_at        (deleted_at)
#  index_chat_participants_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (user_id => users.id)
#
class ChatParticipant < ApplicationRecord
  acts_as_paranoid

  belongs_to :chat
  belongs_to :user
  belongs_to :last_read_message, class_name: "Message", optional: true

  validates :user_id, uniqueness: { scope: :chat_id, conditions: -> { where(deleted_at: nil) } }
end
