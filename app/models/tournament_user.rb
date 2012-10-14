class TournamentUser < ActiveRecord::Base
  #associations
  belongs_to :user
  belongs_to :tournament
end

# == Schema Information
#
# Table name: tournament_users
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  tournament_id :integer          not null
#  admin         :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

