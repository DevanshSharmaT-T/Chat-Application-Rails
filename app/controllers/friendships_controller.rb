class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:update, :destroy]

  def update
    if @friendship.addressee_id == current_user.id
      if @friendship.update(friendship_params)
        @friendship.update(accepted_at: Time.current) if @friendship.accepted?

        redirect_back fallback_location: dashboard_users_path, notice: "Friendship accepted !"
      else
        redirect_back fallback_location: dashboard_users_path, alert: "Unable to process"
      end
    else
      redirect_back fallback_location: dashboard_users_path, alert: "Unauthorized action."
    end
  end

  def destroy
    if @friendship.requester_id == current_user.id || @friendship.addressee_id == current_user.id
      @friendship.destroy
      redirect_back fallback_location: dashboard_users_path, notice: "Friend removed."
    else
      redirect_back fallback_location: dashboard_users_path, alert: "Not your business."
    end
  end

  private

  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:status)
  end
end
