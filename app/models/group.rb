class Group < ApplicationRecord

  acts_as_paranoid

  belongs_to :user
  has_many :group_members
  has_many :users, though: :group_members

  has_one :chat, as: :chatable, dependent: :destroy

  after_create :create_group_chat

end
