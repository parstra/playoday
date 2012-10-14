class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :redirect_logged_in_users

  private

  def redirect_logged_in_users
    if user_signed_in? && request.path == "/"
      redirect_to tournaments_path
    end
  end

end
