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
#  role                   :integer          default(0)
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
  has_many :friends, dependent: :destroy
  has_many :messages, dependent: :destroy


  enum :status, { user: 0, admin: 1 }


  validates_presence_of :first_name, :last_name, presence: true, length: { minimum: 1 }

  

end
