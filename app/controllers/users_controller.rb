class UsersController < ApplicationController

  def show
    authorize @user
  end

  private


end