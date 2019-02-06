class Ability

  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    
    user ||= User.new # guest user (not logged in)
    
    if user.admin?
      can :manage, :all
    else
      
      can :manage, User, id: user.id
      
      can [:create, :read, :save_layout], Dashboard
      
      can [:update, :destroy, :delete_dashboard], Dashboard, user_id: user.id
      
      
      can :create, Widget
      can [:read, :update, :destroy, :delete_widget], Widget, dashboard: { user_id: user.id }
      
      can :manage, Alert
      can :manage, Bound
    end
  end

end
