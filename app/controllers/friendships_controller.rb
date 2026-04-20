class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:update, :destroy]

  def update
    if @friendship.addressee_id == current_user.first.id
      if @friendship.update(friendship_params)
        @friendship.update(accepted_at: Time.current) if @friendship.accepted?

        redirect_back fallback_location: dashboard_users_path, notice: "Tribe updated!"
      else
        redirect_back fallback_location: dashboard_users_path, alert: "Handshake failed."
      end
    else
      redirect_back fallback_location: dashboard_users_path, alert: "Not your request to touch!"
    end
  end

  def destroy
    if @friendship.requester_id == current_user.id || @friendship.addressee_id == current_user.id
      @friendship.destroy # acts_as_paranoid makes it hide
      redirect_back fallback_location: dashboard_users_path, notice: "Friendship buried."
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
