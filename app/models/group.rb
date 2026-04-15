# == Schema Information
#
# Table name: groups
#
#  id          :uuid             not null, primary key
#  deleted_at  :datetime
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_groups_on_deleted_at  (deleted_at)
#  index_groups_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Group < ApplicationRecord

  acts_as_paranoid

  belongs_to :user
  has_many :group_members
  has_many :users, through: :group_members

  has_one :chat, as: :chatable, dependent: :destroy

  after_create :create_group_chat

  private

  def create_group_chat
    create_chat!(chat_name: name, description: description)
  end

end
