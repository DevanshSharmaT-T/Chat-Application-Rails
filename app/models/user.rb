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
