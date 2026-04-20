# == Schema Information
#
# Table name: attachments
#
#  id               :uuid             not null, primary key
#  attachment_type  :integer          default("image")
#  content_type     :string
#  duration_seconds :integer
#  file_name        :string
#  file_size        :bigint
#  file_url         :string           not null
#  height           :integer
#  thumbnail_url    :string
#  width            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  message_id       :uuid             not null
#
# Indexes
#
#  index_attachments_on_message_id  (message_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_id => messages.id)
#
class Attachment < ApplicationRecord
  belongs_to :message

  enum :attachment_type, { image: 0, video: 1, audio: 2, document: 3, sticker: 4 }

  validates :file_url, presence: true
end
