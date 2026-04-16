# == Schema Information
#
# Table name: message_receipts
#
#  id           :uuid             not null, primary key
#  delivered_at :datetime
#  read_at      :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  message_id   :uuid             not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_message_receipts_on_message_user  (message_id,user_id) UNIQUE
#  index_message_receipts_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => messages.id)
#  fk_rails_...  (user_id => users.id)
#
class MessageReceipt < ApplicationRecord
  belongs_to :message
  belongs_to :user

  validates :user_id, uniqueness: { scope: :message_id }
end
