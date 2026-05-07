class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    friend_ids = Friend.where(user_id: current_user.id).select(:friend_user_id)
    inverse_ids = Friend.where(friend_user_id: current_user.id).select(:user_id)
    @friends_list = current_user.friends
    render layout: false if request.xhr?
  end

  def requests
    @pending_received = current_user.received_friendships.pending
    @pending_sent = current_user.sent_friendships.pending
  end

  def create
    @friendship = current_user.sent_friendships.build(addressee_id: params[:addressee_id])

    if @friendship.save
      redirect_to dashboard_users_path, notice: "Friend request sent!"
    else
      redirect_to dashboard_users_path, alert: "Unable to send request."
    end
  end

  def update
    @friendship = Friendship.find(params[:id])

    if @friendship.addressee_id == current_user.id && @friendship.update(friendship_params)
      @friendship.update(accepted_at: Time.current) if @friendship.accepted?

      redirect_back fallback_location: dashboard_users_path, notice: "Request Accepted!"
    else
      redirect_back fallback_location: requests_friends_path, alert: "Cannot do that."
    end
  end


  def destroy
    @friendship = Friendship.find(params[:id])
    if @friendship.requester_id == current_user.id || @friendship.addressee_id == current_user.id
      @friendship.destroy
      redirect_to requests_friends_path, notice: "Friendship ended."
    else
      redirect_to requests_friends_path, alert: "Not your business."
    end
  end

  private

  def friendship_params
    params.require(:friendship).permit(:status)
  end
end
