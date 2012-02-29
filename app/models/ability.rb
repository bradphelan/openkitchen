class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

    # Can read an event I have been invited to
    can :read, Event do |event|
      event.owner_id == user.id || event.invitations.where{user_id==my{user.id}}.count > 0
    end

    if user.confirmed?
      # Only venues which are managed by the user can be assigned to the event
      can [:create, :update], Event, :owner_id => user.id
    end

    # Can edit an event I am the host for
    can [:invite, :edit, :read, :destroy, :read], Event, :owner_id => user.id

    # Can create a resource for the event I own
    can [:create], Resource do |resource|
      resource.event.owner_id = user.id
    end

    # Can create a resource for the event I am invited to
    can [:show], Resource do |resource|
      resource.event.invited? user
    end

    # Can update an invitation if the user owns it
    can [:show, :update], Invitation, :user_id => user.id

    # Can mail or destroy an invitation if the user is the event owner
    can [:mail, :destroy], Invitation do |invitation|
      invitation.event.owner.id == user.id
    end

    # Can create a resource producter for a resource whose event I am invited to
    can [:create], ResourceProducer do |resource_producer|
      resource_producer.invitation.user_id == user.id &&
        resource_producer.resource.event.invitations.where{user_id==my{user.id}}.count > 0
    end

    # Can complete registration for self
    can [:register], User, :id => user.id

    can [:comment_on], Event do |event|
      event.invited? user
    end

    can [:create, :read], Comment do |comment|
      comment.user_id == user.id and can?(:comment_on, comment.commentable)
    end

    can [:destroy], Comment, :user_id => user.id
    can [:destroy], Comment do |comment|
      comment.commentable.owner_id == user.id
    end

    # Profile
    can [:edit, :update, :show], Profile, :user_id => user.id

    can [:edit], User, :user_id => user.id

    # Venue
    #
    can :read, Venue, :user_venue_managements => { :user_id => user.id }
    if user.confirmed?
      can [:edit, :update], Venue, :user_venue_managements => { :user_id => user.id, :role => "manager" }
      can [:edit, :update], Venue, :user_venue_managements => { :user_id => user.id, :role => "owner" }
      can :destroy, Venue, :user_venue_managements => { :user_id => user.id, :role => :owner }
      can :create, Venue

      can :create, VenueImage, :venue => { :user_venue_managements => { :user_id => user.id, :role => "manager" }}
      can :create, VenueImage, :venue => { :user_venue_managements => { :user_id => user.id, :role => "owner" }}
      can :destroy, VenueImage, :venue => { :user_venue_managements => { :user_id => user.id, :role => "manager" }}
      can :destroy, VenueImage, :venue => { :user_venue_managements => { :user_id => user.id, :role => "owner" }}
    end
 

  end
end
