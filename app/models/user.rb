# == Schema Information
#
# Table name: users
#
#  id                       :uuid             not null, primary key
#  avatar_url               :string
#  bio                      :text
#  deleted_at               :datetime
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  failed_attempts          :integer          default(0), not null
#  first_name               :string           not null
#  last_name                :string           not null
#  last_seen_at             :datetime
#  locale                   :string           default("en")
#  locked_at                :datetime
#  middle_name              :string
#  notification_preferences :jsonb
#  online_status            :integer          default("offline")
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  role                     :integer          default("user")
#  status                   :text
#  timezone                 :string
#  unlock_token             :string
#  username                 :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_users_on_deleted_at            (deleted_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_last_seen_at          (last_seen_at)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :lockable

  acts_as_paranoid

  # Devise & Profile Enums
  enum :role, { user: 0, admin: 1 }
  enum :online_status, { offline: 0, online: 1, away: 2, busy: 3 }, suffix: true

  # Associations - Core
  has_many :device_tokens, dependent: :destroy
  has_many :blocked_users, foreign_key: :blocker_id, dependent: :destroy
  has_many :blocked_by, class_name: "BlockedUser", foreign_key: :blocked_id, dependent: :destroy

  # Associations - Friendships
  has_many :sent_friendships, class_name: "Friendship", foreign_key: :requester_id, dependent: :destroy
  has_many :received_friendships, class_name: "Friendship", foreign_key: :addressee_id, dependent: :destroy
  has_many :added_friends, -> { where(friendships: { status: :accepted }) }, 
             through: :sent_friendships, source: :addressee
  has_many :adding_friends, -> { where(friendships: { status: :accepted }) }, 
             through: :received_friendships, source: :requester

  # Associations - Groups
  has_many :owned_groups, class_name: "Group", foreign_key: :created_by_id, dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members

  # Associations - Chats & Messages
  has_many :chat_participants, dependent: :destroy
  has_many :chats, through: :chat_participants
  has_many :messages, dependent: :destroy
  has_many :message_receipts, dependent: :destroy
  has_many :message_reactions, dependent: :destroy

  # Associations - Notifications
  has_many :notifications, dependent: :destroy
  has_many :triggered_notifications, class_name: "Notification", foreign_key: :actor_id, dependent: :nullify

  # Validations
  validates :first_name, :last_name, :username, presence: true
  validates :username, uniqueness: true, presence: true

  # Scopes
  scope :searchable, -> { where(deleted_at: nil).where.not(role: :admin) }

  def full_name
    [first_name, middle_name, last_name].compact.join(" ")
  end

  def friends
    User.where(id: added_friends.select(:id)).or(User.where(id: adding_friends.select(:id)))
  end

  def appearance_for_friends
    return "offline" if online_status_offline? || status == "invisible"
    "online"
  end
end
