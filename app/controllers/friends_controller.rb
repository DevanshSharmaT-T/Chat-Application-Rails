class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    friend_ids = Friend.where(user_id: current_user.id).select(:friend_user_id)
    inverse_ids = Friend.where(friend_user_id: current_user.id).select(:user_id)
    @friends_list = User.where(id: friend_ids).or(User.where(id: inverse_ids))
    render layout: false if request.xhr?
  end

  def create
    @friendship = current_user.friendships.build(friend_user_id: params[:friend_user_id])

    if @friendship.save
      redirect_to root_path, notice: "Friend added successfully!"
    else
      redirect_to root_path, alert: "Unable to add friend."
    end
  end

  def update
    @friend = Friend.find(params[:id])
    if @friend.friend_user_id == current_user.id && @friend.update(status: params[:friend][:status])
      redirect_to root_path, notice: "Friend request accepted."
    else
      redirect_to root_path, alert: "Unable to accept request."
    end
  end
end