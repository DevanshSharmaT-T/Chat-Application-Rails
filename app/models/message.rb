class Message < ApplicationRecord

  acts_as_paranoid

  belongs_to :user
  belongs_to :chat
end
