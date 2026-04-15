# == Schema Information
#
# Table name: chats
#
#  id            :uuid             not null, primary key
#  chat_name     :string
#  chatable_type :string           not null
#  deleted_at    :datetime
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  chatable_id   :uuid             not null
#
# Indexes
#
#  index_chats_on_chatable    (chatable_type,chatable_id)
#  index_chats_on_deleted_at  (deleted_at)
#
require "test_helper"

class ChatTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
