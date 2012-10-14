class Tournament < ActiveRecord::Base
  belongs_to :company
  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_many :rounds

  belongs_to :winner,  class_name: 'User', foreign_key: :winner_id

  CUP     = 1
  LEAGUE  = 2
  SWEDISH = 3

  AVAILABLE_GAMES = { "Cup (Knock out)" => CUP, "Swedish" => SWEDISH }

  # Tournament statuses
  # When in pending mode a tournament can accept new players and even change
  #  the game type
  PENDING = 0
  # When in open mode the tournament is commencing. No changes to players or
  #  the game engine can be made
  OPEN = 1
  # Tournament is closed means all rounds finished and all match played
  CLOSED = 2

  validates :game_type, :numericality => { only_integer: true }
  validates :name, :owner_id, presence: true
  #validates :duration, :total_rounds, :round_duration, :company_id, presence: true

  validates :name, :owner_id, presence: true

  # TODO: test this
  scope :for_user, lambda{|user|
    includes(:tournament_users).
    where("tournament_users.user_id = :user_id or tournaments.owner_id = :user_id",
          {:user_id => user.id})
  }

  # Returns all tournaments that are not closed (open or pending)
  scope :not_closed, where(status: [OPEN, PENDING])

  before_create :create_tournament_hash

  attr_accessible :name, :description, :game_type, :name, :duration,
    :total_rounds, :round_duration, :started_at

  def active_round
    rounds.active.last
  end

  def cup?
    self.game_type == CUP
  end

  def swedish?
    self.game_type == SWEDISH
  end

  def can_start?
    openable? && users.length >= 2
  end

  def player_count_valid?
    swedish? ||
      (cup? && Math.log2(self.users.length).modulo(1).zero?)
  end

  # Opens a tournament and draws the first round
  #
  # It checks if the tournament can be opened and
  #  if so it moves to the next round by extending
  #  the appropriate module.
  def start
    raise TournamentCannotOpen if !openable?
    raise NotEnoughPlayers if users.length < 2
    raise TournamentPlayerCountInvalid if !player_count_valid?

    self.status = Tournament::OPEN

    # in a cup the rounds are determined by the number of players
    # We add one to divide in case number of players is an odd number (e.g. 15)
    if self.cup?
      player_count = self.users.length

      if player_count.modulo(2).zero?
        self.total_rounds = Math.log2(player_count)
      else
        self.total_rounds = Math.log2(player_count + 1)
      end
    end

    next_round
    self.save!
  end

  def openable?
    self.status == PENDING
  end

  def pending?
    openable?
  end

  def closable?
    last_round? && can_close_round?
  end

  def open?
    self.status == OPEN
  end

  def closed?
    self.status == CLOSED
  end

  def has_next_round?
    !last_round?
  end

  def can_close_round?
    current_round.closable?
  end

  def current_round
    self.rounds.last
  end

  # Moves to the next round if the tournament is already open
  #
  # The actual move will be handled by the CupTournament and
  #  SwedishTournament modules
  def next_round
    raise TournamentNotOpenYet if pending?
    raise TournamentAllRoundsPlayed if !has_next_round?

    if current_round && !current_round.closable?
      raise TournamentNotAllMatchesPlayed
    end

    # check the game engine and extend tournament
    if self.game_type == CUP
      self.extend CupTournament
      self.move_to_next_round
    elsif self.game_type == SWEDISH
      self.extend SwedishTournament
      self.move_to_next_round
    end
  end

  def update_tournament_hash
    create_tournament_hash
  end

  # Closes the tournament
  #
  # It sets status to closed and assigns the winner id
  # It must be the last round and all matches played
  def close
    raise TournamentCannotBeClosed if !closable?

    self.status = CLOSED

    if self.cup?
      self.winner = self.current_round.matches.last.winner
    else
      self.winner = self.leaderboard.first.player
    end

    self.save!
  end

  # Leaderboard only makes sense for swedish tournaments
  #
  # It returns players sorted by wins
  def leaderboard

    round_ids = self.round_ids

    # get win counts by id
    # it will be hash where keys are user ids and values are number of wins
    wins_per_user = Match.where(round_id: round_ids).
      where("winner_id is not null and played = true").
      group(:winner_id).count

    players = self.users.
      sort_by{|p| wins_per_user[p.id] || 0}.reverse

    if self.open?
      total = self.rounds.length - 1
    else
      total = self.total_rounds
    end

    players.map{|player| OpenStruct.new({player: player,
                                         wins: wins_per_user[player.id] || 0,
                                         losses: total - (wins_per_user[player.id] || 0)})}
  end

  def top_three
    leaderboard.slice(0,3)
  end

  private

  def last_round?
    self.rounds.length == self.total_rounds
  end

  def create_tournament_hash
    self.tournament_hash = Digest::MD5.hexdigest("I fart at your general direction #{Time.now} #{rand 1000}")
  end

end

class TournamentCannotOpen < Exception; end
class NotEnoughPlayers < Exception; end
class TournamentNotOpenYet < Exception; end
class TournamentAllRoundsPlayed < Exception; end
class TournamentPlayerCountInvalid < Exception; end
class TournamentNotAllMatchesPlayed < Exception; end
class TournamentCannotBeClosed < Exception; end

# == Schema Information
#
#
# Table name: tournaments
#
#  id              :integer          not null, primary key
#  description     :string(255)
#  tournament_hash :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  game_type       :integer
#  company_id      :integer
#  owner_id        :integer
#  name            :string(255)
#  duration        :integer
#  total_rounds    :integer
#  round_duration  :integer
#  active          :boolean          default(FALSE)
#  started_at      :datetime
#  status          :integer          default(0)
#

