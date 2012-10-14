class Tournament < ActiveRecord::Base
  belongs_to :company
  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_many :rounds

  CUP     = 1
  LEAGUE  = 2
  SWEDISH = 3

  AVAILABLE_GAMES = { cup: CUP, swedish: SWEDISH }

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

  scope :active, where(active: true)
  # TODO: test this
  scope :for_user, lambda{|user|
    includes(:tournament_users).
    where("tournament_users.user_id = :user_id or tournaments.owner_id = :user_id",
          {:user_id => user.id})
  }

  before_create :create_tournament_hash

  attr_accessible :name, :description, :game_type, :name, :duration,
    :total_rounds, :round_duration, :started_at

  def active_round
    rounds.active.last
  end

  # Opens a tournament and draws the first round
  #
  # It checks if the tournament can be opened and
  #  if so it moves to the next round by extending
  #  the appropriate module.
  def start
    raise TournamentCannotOpen if !openable?
    raise NotEnoughPlayers if users.length < 2

    self.status = Tournament::OPEN

    # check the game engine and extend tournament
    if self.game_type == CUP
      self.extend CupTournament
      self.move_to_next_round
    end

    self.save!
  end

  def openable?
    self.status == PENDING
  end

  def open?
    self.status == OPEN
  end

  private

  def create_tournament_hash
    self.tournament_hash = Digest::MD5.hexdigest("I fart at your general direction #{Time.now} #{rand 1000}")
  end

end

class TournamentCannotOpen < Exception; end
class NotEnoughPlayers < Exception; end

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

