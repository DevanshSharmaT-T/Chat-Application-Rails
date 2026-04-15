class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :fetch_pending_requests, if: :user_signed_in?


  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def fetch_pending_requests
    @pending_requests = Friend.where(friend_user_id: current_user.id, status: 'pending')
  end

  def configure_permitted_parameters
      permitted_attributes = [ :first_name, :middle_name, :last_name, :status ]

      devise_parameter_sanitizer.permit(:sign_up, keys: permitted_attributes)
      devise_parameter_sanitizer.permit(:account_update, keys: permitted_attributes)
  end
end
