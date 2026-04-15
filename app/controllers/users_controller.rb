class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def dashboard
     @friends_list = current_user.friends
  end


  def find_friends
    @possible_friends_list = User.possible_friends(current_user)
    if request.xhr?
      render partial: "users/tabs/find_friends", layout: false
    else
      render :dashboard
    end
  end
  
  def show
    # authorize @user
  end

  private


end