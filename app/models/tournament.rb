class Tournament < ActiveRecord::Base
  belongs_to :company
  belongs_to :owner, class_name: :user, foreign_key: :owner_id

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_many :rounds

  CUP     = 1
  LEAGUE  = 2
  SWEDISH = 3

  validates :game_type, :numericality => { only_integer: true }

  def create_tournament_hash!
    self.tournament_hash = Digest::MD5.hexdigest("I fart at your general direction #{self.id}")
    save
  end

end
