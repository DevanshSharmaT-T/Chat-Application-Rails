# == Schema Information
#
# Table name: message_reactions
#
#  id         :uuid             not null, primary key
#  emoji      :string           not null
#  created_at :datetime         not null
#  message_id :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_message_reactions_on_message_user_emoji  (message_id,user_id,emoji) UNIQUE
#  index_message_reactions_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => messages.id)
#  fk_rails_...  (user_id => users.id)
#
class MessageReaction < ApplicationRecord
  belongs_to :message
  belongs_to :user

  validates :emoji, presence: true
  validates :user_id, uniqueness: { scope: [:message_id, :emoji] }
end
