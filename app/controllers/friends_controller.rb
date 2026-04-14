class FriendsController < ApplicationController

  before_action :set_user

  def index
    @friends_list = @user.friends.to_a
  end


end