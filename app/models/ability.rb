class Ability
  include CanCan::Ability

  def initialize(user)
    owned_project_ids  = user.projects.pluck(:id)
    member_project_ids = user.memberships.authorized.pluck(:project_id)

    can :manage, Membership, Membership do |membership|
      true
    end

    can :manage, Project, { user_id: user.id }
    can :advance, Project, { user_id: user.id }

    can :read,   Project, { public: true }
    can :read,   Project, { id: member_project_ids }
    can :tactical,  Project, { public: true }
    can :strategic, Project, { public: true }
    can :tactical,  Project, { id: member_project_ids }
    can :strategic, Project, { id: member_project_ids }

    can :manage, Role, { project_id: owned_project_ids }
    can :read,   Role, { project_id: member_project_ids }

    # TODO: Should probably also allow public projects to :read, yeah?
    can :manage, Obstacle, { project_id: owned_project_ids }
    can :manage, Obstacle, { project_id: member_project_ids }

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
