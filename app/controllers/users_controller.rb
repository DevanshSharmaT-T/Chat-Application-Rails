class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: :show
  
  def dashboard
    @friends_list = current_user.friends
  end


  def find_friends
    @possible_friends_list = User.searchable.where.not(id: current_user.id)

    if request.xhr?
      render partial: "users/tabs/find_friends", layout: false
    else
      dashboard
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
