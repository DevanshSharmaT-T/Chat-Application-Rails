class FriendsController < ApplicationController

  def index
    @friends_list = current_user.friends.to_a
  end
  
  def search
    # @possible_friends_list = current_user.possible_friends
  end

end