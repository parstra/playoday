class Match < ActiveRecord::Base
  belongs_to :round

  belongs_to :home_player, class_name: 'User', foreign_key: :home_player_id
  belongs_to :away_player, class_name: 'User', foreign_key: :away_player_id
  belongs_to :winner,      class_name: 'User', foreign_key: :winner_id

  def played?
    played
  end

  def create_match_hash!
    self.match_hash = Digest::MD5.hexdigest("I fart at your general direction #{self.id}")
    save
  end
end

# == Schema Information
#
# Table name: matches
#
#  id             :integer          not null, primary key
#  round_id       :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  matchdate      :datetime
#  match_hash     :string(255)
#  home_score     :integer
#  away_score     :integer
#  played         :boolean          default(FALSE)
#  home_player_id :integer
#  away_player_id :integer
#  winner_id      :integer
#

