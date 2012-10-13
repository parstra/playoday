class TournamentsController < ApplicationController
  before_filter :authenticate_user!

  # GET /index
  def index
    @tournaments = Tournament.for_user(current_user).
                              order("tournaments.created_at desc")
  end
end
