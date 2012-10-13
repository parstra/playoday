class TournamentsController < ApplicationController
  before_filter :authenticate_user!

  # GET /index
  def index
    @my_tournaments = Tournament.where(owner_id: current_user.id).
                                 order("created_at desc")

    @other_tournaments = Tournament.
                          joins(:tournament_users).
                          where("tournament_users.user_id" => current_user.id).
                          order("created_at desc")
  end
end
