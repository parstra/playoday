class TournamentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :fetch_tournament, :only => [:show, :edit, :update]
  before_filter :authorize, :only => [:show, :edit]

  # GET /index
  def index
    @tournaments = Tournament.for_user(current_user).
                              order("tournaments.created_at desc")
  end

  # GET /show/id
  def show
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

  def authorize
    # can user see this?
    # TODO: cancan this
    if @tournament.owner_id != current_user.id &&
      TournamentUser.where(tournament_id: @tournament.id,
                           user_id: current_user.id).count == 0
      flash[:alert] = "You are not supposed to be here"
      redirect_to tournaments_path
      return false
    end
    true
  end
end
