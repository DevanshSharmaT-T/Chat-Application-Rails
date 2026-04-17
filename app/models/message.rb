# == Schema Information
#
# Table name: messages
#
#  id         :uuid             not null, primary key
#  body       :text             not null
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chat_id    :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_messages_on_chat_id     (chat_id)
#  index_messages_on_deleted_at  (deleted_at)
#  index_messages_on_id          (id)
#  index_messages_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (user_id => users.id)
#
class Message < ApplicationRecord

  acts_as_paranoid
  self.primary_key = :id

  belongs_to :user
  belongs_to :chat

  validates :body, presence: true

  after_create_commit :broadcast_message

  private

  def broadcast_message
    msg_user = user || User.find(user_id)

    payload = {
      id: id,
      body: body,
      chat_id: chat_id,
      user_id: user_id,
      user_name: msg_user.full_name,
      created_at: created_at.iso8601,
      time_ago: "less than a minute"
    }
    ActionCable.server.broadcast("chat_#{chat_id}", payload)
  end
end
