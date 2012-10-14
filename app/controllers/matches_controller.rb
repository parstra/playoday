class MatchesController < ApplicationController
  before_filter :authenticate_user!
#  load_and_authorize_resource :tournament
  load_and_authorize_resource :match

  before_filter :fetch_match_and_tournament, only: [:edit, :update, :trashtalk]

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

  #POST /tournaments/1/matches/2/trashtalk
  def trashtalk

    if params[:comment].blank? || !@match.round.active || @match.played?
      redirect_to tournament_path(@tournament)
      return
    end

    if current_user == @match.home_player
      if !@match.home_comment
        @match.home_comment = params[:comment]
        @match.save
      end
    elsif current_user == @match.away_player
      if !@match.away_comment
        @match.away_comment = params[:comment]
        @match.save
      end
    end

    redirect_to tournament_path(@tournament)

  end

  private

  def fetch_match_and_tournament
    @match = Match.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])
  end

  rescue_from CanCan::AccessDenied do |exception|
    puts exception.message
    redirect_to tournaments_path, :alert => exception.message
  end


end
