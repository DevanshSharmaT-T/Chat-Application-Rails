class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat
  before_action :authorize_chat!

  def show
    messages_scope = @chat.messages.includes(:user).order(created_at: :desc).page(params[:page]).per(20)
    @messages = messages_scope.to_a.reverse
    @next_page = messages_scope.next_page

    respond_to do |format|
      format.html do
        if request.xhr?
          if params[:prepend].present?
            render partial: "messages/history_messages", locals: { messages: @messages, next_page: @next_page }
          else
            render partial: "messages/chat_window", locals: { chat: @chat, messages: @messages, next_page: @next_page }
          end
        else
          redirect_to dashboard_users_path
        end
      end
      format.json { render json: @messages }
    end
  end

  def create
    @message = @chat.messages.build(message_params.merge(user: current_user))

    if @message.save
      render json: { 
        status: 'success', 
        message: @message, 
        html: ApplicationController.render(
          partial: 'messages/message_bubble',
          locals: { message: @message, current_user: current_user }
        )
      }, status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def authorize_chat!
    authorize @chat, :show?
  end

  def message_params
    params.require(:message).permit(:body)
  end
end