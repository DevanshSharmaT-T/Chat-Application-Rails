class FriendsController < ApplicationController

  def index
    @friends_list = @user.friends.to_a
  end


end