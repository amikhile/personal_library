class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user

    # Roles:
    if user.role? :admin
      #- Admin - Can do everything
      can :manage, :all
      can :search_secure, :all
    elsif user.role? :advanced_user
      #- Advanced user - Can search for secure files
      can :manage, :all
      can :search_secure, :all
      cannot [:show_user_logins], :report
    elsif user.role? :simple_user
      can :manage, :all
      cannot :manage, User
      cannot :search_secure, :all
      cannot [:show_user_logins], :report
    else # Guest
    end

  end
end
