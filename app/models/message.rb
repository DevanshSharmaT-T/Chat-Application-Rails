# == Schema Information
#
# Table name: messages
#
#  id                :uuid             not null, primary key
#  body              :text
#  deleted_at        :datetime
#  edited_at         :datetime
#  is_edited         :boolean          default(FALSE)
#  message_type      :integer          default("text")
#  metadata          :jsonb
#  status            :integer          default("sent")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  chat_id           :uuid             not null
#  forwarded_from_id :uuid
#  reply_to_id       :uuid
#  user_id           :uuid             not null
#
# Indexes
#
#  index_messages_on_chat_id_created_at  (chat_id,created_at)
#  index_messages_on_deleted_at          (deleted_at)
#  index_messages_on_metadata_gin        (metadata) USING gin
#  index_messages_on_reply_to_id         (reply_to_id)
#  index_messages_on_user_id             (user_id)
                                    #  index_messages_on_chat_id     (chat_id)
                                    #  index_messages_on_deleted_at  (deleted_at)
                                    #  index_messages_on_id          (id)
                                    #  index_messages_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chat_id => chats.id)
#  fk_rails_...  (forwarded_from_id => messages.id)
#  fk_rails_...  (reply_to_id => messages.id)
#  fk_rails_...  (user_id => users.id)
#
class Message < ApplicationRecord
  acts_as_paranoid
  self.primary_key = :id

  belongs_to :user
  belongs_to :chat
  belongs_to :reply_to, class_name: "Message", optional: true
  belongs_to :forwarded_from, class_name: "Message", optional: true

  has_many :receipts, class_name: "MessageReceipt", dependent: :destroy
  has_many :reactions, class_name: "MessageReaction", dependent: :destroy
  has_many :attachments, dependent: :destroy

  enum :message_type, { text: 0, image: 1, video: 2, audio: 3, file: 4, system: 5, sticker: 6 }, suffix: true
  enum :status, { sent: 0, delivered: 1, read: 2 }

  # No longer validates :body presence due to attachment-only messages
  validate :must_have_body_or_attachment

  after_create_commit :broadcast_message

  private

  def must_have_body_or_attachment
    if body.blank? && attachments.empty?
      errors.add(:base, "Message must have text or an attachment")
    end
  end

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
