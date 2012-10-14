class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :redirect_logged_in_users

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      tournaments_path
    end
  end

  private

  def redirect_logged_in_users
    if user_signed_in? && request.path == "/"
      redirect_to tournaments_path
    end
  end

end
