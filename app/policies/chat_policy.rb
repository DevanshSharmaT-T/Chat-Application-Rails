class ChatPolicy < ApplicationPolicy
  def show?
    return false unless user.present?

    return true if record.chatable_type == "Friend" &&
                   (record.chatable.user_id == user.id || record.chatable.friend_user_id == user.id)

    return true if record.chatable_type == "Group" &&
                   record.chatable.group_members.exists?(user_id: user.id)

    false
  end

  def create_message?
    show?
  end
end
