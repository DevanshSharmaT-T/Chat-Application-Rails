# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  locked_at              :datetime
#  middle_name            :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user")
#  status                 :text
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :lockable

  acts_as_paranoid

  has_many :group_members
  has_many :groups, through: :group_members
  has_many :owned_groups, class_name: "Group", foreign_key: :user_id, dependent: :destroy
  has_many :friendships, class_name: "Friend", dependent: :destroy
  has_many :friend_users, through: :friendships, source: :friend_user
  has_many :inverse_friendships, class_name: "Friend", foreign_key: :friend_user_id, dependent: :destroy
  has_many :inverse_friend_users, through: :inverse_friendships, source: :user
  has_many :messages, dependent: :destroy


  enum :role, { user: 0, admin: 1 }
  # enum :visibility, { active: 0, inactive: 1, only_friends: 2, default: 3}

  validates_presence_of :first_name, :last_name, presence: true, length: { minimum: 1 }

  scope :searchable, -> { where( status: [ :online, :invisible]) }
  scope :possible_friends, ->(user) {
    friend_ids = Friend.where(user_id: user.id).select(:friend_user_id)
    inverse_friend_ids = Friend.where(friend_user_id: user.id).select(:user_id)
    searchable
        .where.not(id: user.id)
        .where.not(id: friend_ids)
        .where.not(id: inverse_friend_ids)
        .where(deleted_at: nil)
        .where.not(role: :admin)
  }
  
  def appearance_for_friends
      return "offline" if invisible? || offline?
      "online"
  end
  
  
  def full_name
      [first_name, middle_name, last_name].compact.join(" ")
  end
  

end
