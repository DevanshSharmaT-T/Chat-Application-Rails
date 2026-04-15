class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups_list = current_user.groups
    render layout: false if request.xhr?
  end
end
