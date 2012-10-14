class Round < ActiveRecord::Base
  belongs_to :tournament
  has_many :matches

  scope :active, where(active: true)

  # Determines if this round can be closed
  #
  # All matches must be played and have and winner_id
  def closable?
    self.matches.select{|m| !m.played}.empty?
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id            :integer          not null, primary key
#  tournament_id :integer          not null
#  round_number  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  started_at    :datetime
#  ended_at      :datetime
#  active        :boolean
#

