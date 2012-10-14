class TournamentsController < ApplicationController
  load_and_authorize_resource

  before_filter :authenticate_user!
  before_filter :fetch_tournament, :only => [:show, :edit]

  # GET /index
  def index
    @tournaments = Tournament.for_user(current_user).
                              order("tournaments.created_at desc")

  end

  # GET /show/id
  def show

    # get last round of this tournament
    if @tournament.open?
      @round = @tournament.rounds.includes({matches:
                                            [:home_player, :away_player]
                                           }).last
      @matches = @round.matches
    end
  end

  # GET new
  def new
    @tournament = Tournament.new
  end

  # GET edit
  def edit
  end

  # PUT update
  def update
    if @tournament.update_attributes(params[:tournament])
      redirect_to tournament_path(@tournament), {
        notice: 'Tournament updated'
      }
    else
      flash[:alert] = "Could not update tournament"
      render :edit
    end
  end

  # POST create
  def create
    @tournament = Tournament.new(params[:tournament])
    @tournament.owner = current_user

    if @tournament.save
      flash[:notice] = "Tournament successfully created"
      redirect_to tournament_path(@tournament)
    else
      flash[:alert] = "Could not save tournament."
      render :new
    end

  end

  private
  def fetch_tournament
    @tournament = Tournament.find(params[:id])
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to tournaments_path, :alert => exception.message
  end
end
