class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: :show
  
  def dashboard
    friend_ids = Friend.where(user_id: current_user.id).select(:friend_user_id)
    inverse_ids = Friend.where(friend_user_id: current_user.id).select(:user_id)
    @friends_list = User.where(id: friend_ids).or(User.where(id: inverse_ids))
  end


  def find_friends
    @possible_friends_list = User.possible_friends(current_user)
    if request.xhr?
      render partial: "users/tabs/find_friends", layout: false
    else
      friend_ids = Friend.where(user_id: current_user.id).select(:friend_user_id)
      inverse_ids = Friend.where(friend_user_id: current_user.id).select(:user_id)
      @friends_list = User.where(id: friend_ids).or(User.where(id: inverse_ids))
      render :dashboard
    end
  end

  def show
    if @user != current_user
      redirect_to dashboard_users_path, alert: "You are not authorized to view this profile."
      return
    end
  end

  private

  def set_user
    @user = current_user
  end

end