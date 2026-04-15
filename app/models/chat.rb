# == Schema Information
#
# Table name: chats
#
#  id            :uuid             not null, primary key
#  chat_name     :string
#  chatable_type :string           not null
#  deleted_at    :datetime
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  chatable_id   :uuid             not null
#
# Indexes
#
#  index_chats_on_chatable    (chatable_type,chatable_id)
#  index_chats_on_deleted_at  (deleted_at)
#
class Chat < ApplicationRecord

  acts_as_paranoid

  belongs_to :chatable, polymorphic: true
  has_many :messages, dependent: :destroy
end
