# == Schema Information
#
# Table name: friendships
#
#  id           :uuid             not null, primary key
#  accepted_at  :datetime
#  deleted_at   :datetime
#  status       :integer          default("pending")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  addressee_id :uuid             not null
#  requester_id :uuid             not null
#
# Indexes
#
#  index_friendships_on_addressee_id                (addressee_id)
#  index_friendships_on_deleted_at                  (deleted_at)
#  index_friendships_on_requester_addressee_active  (requester_id,addressee_id) UNIQUE WHERE (deleted_at IS NULL)
#  index_friendships_on_requester_id                (requester_id)
#
# Foreign Keys
#
#  fk_rails_...  (addressee_id => users.id)
#  fk_rails_...  (requester_id => users.id)
#
class Friendship < ApplicationRecord
  acts_as_paranoid

  belongs_to :requester, class_name: "User"
  belongs_to :addressee, class_name: "User"
  has_one :chat, as: :chatable, dependent: :destroy

  enum :status, { pending: 0, accepted: 1, declined: 2, blocked: 3 }

  validates :requester_id, uniqueness: { scope: :addressee_id, conditions: -> { where(deleted_at: nil) } }

  after_create :create_dm

  scope :pending_requests, ->(user) { where(status: :pending, addressee_id: user.id) }
  scope :sent_requests, ->(user) { where(status: :pending, requester_id: user.id) }
  scope :accepted_friendships, ->(user) { where(status: :accepted).where("requester_id = ? OR addressee_id = ?", user.id, user.id) }

  private

  def create_dm
    create_chat!(chat_name: "#{requester.full_name} & #{addressee.full_name}", chat_type: :direct)
  end
end
