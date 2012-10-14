class TournamentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  before_filter :fetch_tournament, :only => [:show, :edit,
                                             :recreate_tournament_hash,
                                             :next_round,
                                             :close,
                                             :start]

  # GET /index
  def index
    @tournaments = Tournament.for_user(current_user).
                              order("tournaments.created_at desc")

    unless params[:all]
      @tournaments = @tournaments.not_closed.
        reorder("status asc, tournaments.created_at desc")
    end

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

  # POST /start
  def start
    authorize! :manage, @tournament

    begin
      @tournament.start

    rescue NotEnoughPlayers
      flash[:alert] = "Not enough players to start this tournament"
      return redirect_to tournament_path(@tournament)
    rescue TournamentCannotOpen
      flash[:alert] = "You cannot open this tournament"
      return redirect_to tournament_path(@tournament)
    rescue TournamentPlayerCountInvalid
      flash[:alert] = "You need powers of two number of players for a cup"
      return redirect_to tournament_path(@tournament)
    end

    flash[:notice] = "Tournament started successfully"
    redirect_to tournament_path(@tournament)
  end

  # POST /next_round
  def next_round
    authorize! :manage, @tournament

    begin
      @tournament.next_round
    rescue TournamentAllRoundsPlayed
      flash[:alert] = "No more rounds for this tournament. Please close it"
      return redirect_to tournament_path(@tournament)
    rescue TournamentNotAllMatchesPlayed
      flash[:alert] = "You must play all matches before closing a round"
      return redirect_to tournament_path(@tournament)
    end

    flash[:notice] = "Next round succesfully registered"
    redirect_to tournament_path(@tournament)
  end

  def close
    authorize! :manage, @tournament

    begin
      @tournament.close

    rescue TournamentCannotBeClosed
      flash[:alert] = "Cannot close this tournament"
      return redirect_to tournament_path(@tournament)
    end

    flash[:notice] = "Tournament closed successfully"
    redirect_to tournament_path(@tournament)
  end

  private
  def fetch_tournament
    @tournament = Tournament.find(params[:id])
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to tournaments_path, :alert => exception.message
  end
end
