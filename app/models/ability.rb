class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Tournament, tournament_users: { user_id: user.id }
    can :manage, Tournament, owner_id: user.id
  end
end
