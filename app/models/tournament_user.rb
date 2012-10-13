class TournamentUser < ActiveRecord::Base
  #associations
  belongs_to :user
  belongs_to :tournament
end
