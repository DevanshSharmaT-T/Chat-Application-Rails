class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups_list = current_user.groups
    render layout: false if request.xhr?
  end

  def new
    @group = Group.new
    # Only accepted friends can be added to groups
    accepted_friend_ids = Friend.where(user_id: current_user.id, status: :accepted).select(:friend_user_id)
    accepted_inverse_ids = Friend.where(friend_user_id: current_user.id, status: :accepted).select(:user_id)
    @accepted_friends = User.where(id: accepted_friend_ids).or(User.where(id: accepted_inverse_ids))
  end

  def create
    @group = current_user.owned_groups.build(group_params)

    if @group.save
      # Add selected friends as group members
      if params[:member_ids].present?
        # Verify each member is an accepted friend before adding
        allowed_ids = accepted_friend_ids_for(current_user)
        valid_member_ids = Array(params[:member_ids]).select { |id| allowed_ids.include?(id) }
        valid_member_ids.each do |member_id|
          @group.group_members.create!(user_id: member_id)
        end
      end
      # Add creator as member too
      @group.group_members.find_or_create_by!(user_id: current_user.id)
      redirect_to dashboard_users_path, notice: "Tribe '#{@group.name}' created!"
    else
      accepted_friend_ids = Friend.where(user_id: current_user.id, status: :accepted).select(:friend_user_id)
      accepted_inverse_ids = Friend.where(friend_user_id: current_user.id, status: :accepted).select(:user_id)
      @accepted_friends = User.where(id: accepted_friend_ids).or(User.where(id: accepted_inverse_ids))
      render :new
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :description)
  end

  def accepted_friend_ids_for(user)
    sent = Friend.where(user_id: user.id, status: :accepted).pluck(:friend_user_id)
    received = Friend.where(friend_user_id: user.id, status: :accepted).pluck(:user_id)
    (sent + received).map(&:to_s)
  end
end
