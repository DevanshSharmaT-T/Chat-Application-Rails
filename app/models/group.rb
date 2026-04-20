# == Schema Information
#
# Table name: groups
#
#  id            :uuid             not null, primary key
#  avatar_url    :string
#  deleted_at    :datetime
#  description   :text
#  group_type    :integer          default("private_group")
#  invite_code   :string
#  max_members   :integer          default(256)
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :uuid             not null
#
# Indexes
#
#  index_groups_on_created_by_id                (created_by_id)
#  index_groups_on_deleted_at                   (deleted_at)
#  index_groups_on_invite_code_unique_not_null  (invite_code) UNIQUE WHERE (invite_code IS NOT NULL)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
class Group < ApplicationRecord

  acts_as_paranoid

  belongs_to :creator, class_name: "User", foreign_key: "created_by_id"
  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members

  has_one :chat, as: :chatable, dependent: :destroy
  has_many :chat_participants, through: :chat

  enum :group_type, { private_group: 0, public_group: 1, broadcast: 2 }

  validates :name, presence: true

  after_create :create_group_chat

  private

  def create_group_chat
    create_chat!(chat_name: name, description: description, chat_type: :group)
  end
end
