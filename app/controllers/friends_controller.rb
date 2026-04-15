class FriendsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @friends_list = current_user.friends
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
end