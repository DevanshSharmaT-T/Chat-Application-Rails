# == Schema Information
#
# Table name: device_tokens
#
#  id           :uuid             not null, primary key
#  device_name  :string
#  last_used_at :datetime
#  platform     :integer          not null
#  token        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_device_tokens_on_token    (token) UNIQUE
#  index_device_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class DeviceToken < ApplicationRecord
  belongs_to :user

  enum :platform, { ios: 0, android: 1, web: 2 }

  validates :token, presence: true, uniqueness: true
  validates :platform, presence: true
end
