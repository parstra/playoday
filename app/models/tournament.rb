class Tournament < ActiveRecord::Base
  has_many :rounds

  CUP     = 1
  LEAGUE  = 2
  SWEDISH = 3

  validates :game_type, :numericality => { only_integer: true }
end
