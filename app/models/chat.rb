# == Schema Information
#
# Table name: chats
#
#  id               :uuid             not null, primary key
#  chat_name        :string
#  chat_type        :integer          default("direct")
#  chatable_type    :string           not null
#  deleted_at       :datetime
#  description      :text
#  last_activity_at :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  chatable_id      :uuid             not null
#  last_message_id  :uuid
#
# Indexes
#
#  index_chats_on_chatable          (chatable_type,chatable_id)
#  index_chats_on_deleted_at        (deleted_at)
#  index_chats_on_last_activity_at  (last_activity_at)
#
# Foreign Keys
#
#  fk_rails_...  (last_message_id => messages.id)
#
class Chat < ApplicationRecord

  acts_as_paranoid

  belongs_to :chatable, polymorphic: true
  belongs_to :last_message, class_name: "Message", optional: true

  has_many :messages, dependent: :destroy
  has_many :participants, class_name: "ChatParticipant", dependent: :destroy
  has_many :users, through: :participants
  has_many :pinned_messages, dependent: :destroy

  enum :chat_type, { direct_message: 0, group_chat: 1, broadcast_group: 2 }
end
