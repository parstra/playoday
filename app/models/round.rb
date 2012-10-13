class Round < ActiveRecord::Base
  belongs_to :tournament
  has_many :matches
end

# == Schema Information
#
# Table name: rounds
#
#  id            :integer          not null, primary key
#  tournament_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

