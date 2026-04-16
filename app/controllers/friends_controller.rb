class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    friend_ids = Friend.where(user_id: current_user.id).select(:friend_user_id)
    inverse_ids = Friend.where(friend_user_id: current_user.id).select(:user_id)
    @friends_list = User.where(id: friend_ids).or(User.where(id: inverse_ids))
    render layout: false if request.xhr?
  end

  def requests
    @pending_received = Friend.includes(:user)
                              .where(friend_user_id: current_user.id, status: :pending)
    @pending_sent = Friend.includes(:friend_user)
                          .where(user_id: current_user.id, status: :pending)
  end

  def create
    @friendship = current_user.friendships.build(friend_user_id: params[:friend_user_id])

    if @friendship.save
      redirect_to dashboard_users_path, notice: "Friend request sent!"
    else
      redirect_to dashboard_users_path, alert: "Unable to send request."
    end
  end

  def update
    @friend = Friend.find(params[:id])
    if @friend.friend_user_id == current_user.id && @friend.update(status: params[:friend][:status])
      redirect_to requests_friends_path, notice: "Request accepted! You can now chat."
    else
      redirect_to requests_friends_path, alert: "Cannot accept this request."
    end
  end

  def destroy
    @friend = Friend.find(params[:id])
    if @friend.user_id == current_user.id || @friend.friend_user_id == current_user.id
      @friend.destroy
      redirect_to requests_friends_path, notice: "Request removed."
    else
      redirect_to requests_friends_path, alert: "Cannot remove this."
    end
  end
end