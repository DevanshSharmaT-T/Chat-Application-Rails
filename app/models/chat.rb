class Chat < ApplicationRecord

  acts_as_paranoid

  belongs_to :chatable, polymorphic: true
  has_many :messages, dependent: :destory
end
