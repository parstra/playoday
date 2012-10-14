class MatchesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :tournament
  load_and_authorize_resource :match

  before_filter :fetch_match_and_tournament, only: [:edit, :update]

  def edit
  end

  def update
    if @match.update_attributes(params[:match])
      redirect_to tournament_path(@tournament), {
        notice: 'Match updated'
      }
    else
      flash[:alert] = "Could not update tournament"
      render :edit
    end
  end

  private

  def fetch_match_and_tournament
    @match = Match.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to tournaments_path, :alert => exception.message
  end

  def trashtalk
  end

end
