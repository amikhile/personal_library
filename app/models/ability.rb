class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    # Roles:
    if user.role? :admin
      #- Admin - Can do everything
      can :manage, :all
    elsif user.role? :simple_user
      can :manage, :all
      cannot :manage, User
    else # Guest
    end

  end
end
