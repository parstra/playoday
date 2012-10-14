class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Tournament, tournament_users: { user_id: user.id }
    can :manage, Tournament, owner_id: user.id

    can :update, Match do |match|
      (match.away_player_id ==  user.id || match.home_player_id == user.id ||
        match.round.tournament.owner_id == user.id) &&
        (!match.played && match.updated_at > 1.day.ago)
    end
  end
end
