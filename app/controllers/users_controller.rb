class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    authorize @user
  end

  private


end