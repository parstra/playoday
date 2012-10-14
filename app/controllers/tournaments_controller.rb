class TournamentsController < ApplicationController
  load_and_authorize_resource

  before_filter :authenticate_user!
  before_filter :fetch_tournament, :only => [:show, :edit, :recreate_tournament_hash]

  # GET /index
  def index
    @tournaments = Tournament.for_user(current_user).
                              order("tournaments.created_at desc")
  end

  # GET /register/:tournament_hash
  def register
    @tournament = Tournament.find_by_tournament_hash(params[:tournament_hash])
    if !@tournament.nil? && @tournament.status == Tournament::PENDING &&
        !current_user.tournaments.include?(@tournament)
      current_user.tournaments << @tournament
      current_user.save
      flash[:notice] = "You have successfully register to the tournament"
      redirect_to tournament_path(@tournament)
    else
      flash[:alert] = "Could not register to this tournament"
      redirect_to tournaments_path
    end
  end

  # POST /recreate_tournament_hash/:id
  def recreate_hash
    if @tournament.status == Tournament::PENDING
      @tournament.update_tournament_hash
      @tournament.save
      flash[:notice] = "Tournament hash has successfully recreated"
      redirect_to tournament_path(@tournament)
    else
      flash[:alert] = "Could not register to this tournament"
      redirect_to tournaments_path
    end
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
