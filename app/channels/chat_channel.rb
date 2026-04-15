class ChatChannel < ApplicationCable::Channel
  def subscribed
    @chat = Chat.find_by(id: params[:chat_id])
    reject unless @chat

    policy = ChatPolicy.new(current_user, @chat)
    reject unless policy.show?

    stream_from "chat_#{@chat.id}"
  end

  def speak(data)
    return unless @chat

    policy = ChatPolicy.new(current_user, @chat)
    return unless policy.create_message?

    body = data["body"].to_s.strip
    return if body.blank?

    @chat.messages.create!(user: current_user, body: body)
  end
end
