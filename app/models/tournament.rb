class Tournament < ActiveRecord::Base
  belongs_to :company
  belongs_to :owner, class_name: "User", foreign_key: :owner_id

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_many :rounds

  CUP     = 1
  LEAGUE  = 2
  SWEDISH = 3

  validates :game_type, :numericality => { only_integer: true }
  validates :name, :duration, :total_rounds, :round_duration, :owner_id, :company_id, presence: true

  scope :active, where(active: true)
  # TODO: test this
  scope :for_user, lambda{|user|
    includes(:tournament_users).
    where("tournament_users.user_id = :user_id or tournaments.owner_id = :user_id",
          {:user_id => user.id})
  }

  before_create :create_tournament_hash

  def active_round
    rounds.active.last
  end

  private

  def create_tournament_hash
    self.tournament_hash = Digest::MD5.hexdigest("I fart at your general direction #{Time.now} #{rand 1000}")
  end

end

# == Schema Information
#
# Table name: tournaments
#
#  id              :integer          not null, primary key
#  description     :string(255)      not null
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
#

