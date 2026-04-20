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
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
