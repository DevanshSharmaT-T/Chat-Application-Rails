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
    html = ApplicationController.render(
      partial: 'messages/message_bubble',
      locals: { message: self, current_user: nil } # current_user is nil in broadcast, JS flips it
    )

    ActionCable.server.broadcast("chat_#{chat_id}", {
      html: html,
      user_id: user_id,
      chat_id: chat_id
    })
  end

end
