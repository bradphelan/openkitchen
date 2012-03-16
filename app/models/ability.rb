class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
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
    can :read, Event, :owner_id => user.id
    can :read, Event, :invitations => { :user_id => user.id }
    can :read, Event, :public => true

    if user.confirmed?
      can [:edit, :create, :update, :destroy], Event, :owner_id => user.id
    end

    can :register_any_email_for_event, Event, :owner_id => user.id

    if not user.id
      can :register_non_existing_user_for_event, Event, :public => true
    else
      can :register_current_user_for_event, Event, :public => true
    end


    # Can create a resource for the event I own
    can :create, Resource, :event => { :owner_id => user.id }

    # Can show a resource for the event I am invited to
    can :show, Resource, :event => { :invitations => { :user_id => user.id }}

    # Can update an invitation if the user owns it
    can [:show, :update], Invitation, :user_id => user.id

    # Can mail or destroy an invitation if the user is the event owner
    can [:mail, :destroy], Invitation, :event => { :owner_id => user.id }

    # Can create a resource producter for a resource whose event I am invited to
    can :create, ResourceProducer, 
      :invitation => { :user_id => user.id }, 
      :resource => { :event => { :invitations => { :user_id => user.id } } }

    # Can complete registration for self
    can [:register], User, :id => user.id

    can [:comment_on], Event, { :invitations => { :user_id => user.id } } 

    # TODO THE BELOW IS NOT CORRECT
    can [:comment_on], Event, { :public => true } 
    cannot :comment_on, Event do
      user.id.nil?
    end 

    can [:create, :read], Comment do |comment|
      comment.user_id == user.id and can?(:comment_on, comment.commentable)
    end

    can [:destroy], Comment, :user_id => user.id, :commentable => { :owner_id => user.id }

    # User
    can [:edit, :show, :update], User, :id => user.id

    # Can see a user profile if you are invited to the users event
    can :show, User, :events_as_owner => { :invitations => { :user_id => user.id }}
    # Can see a user profile if you have invited a user to your event
    can :show, User, :invitations => { :event => { :owner_id => user.id } }

    can :sign_in, User

    # Venue
    #
    can :read, Venue, :user_venue_managements => { :user_id => user.id }
    can :read, Venue, :events => { :invitations => { :user_id => user.id }}

    if user.confirmed?
      can [:show, :edit, :update], Venue, :user_venue_managements => { :user_id => user.id, :role => "manager" }
      can [:show, :edit, :update], Venue, :user_venue_managements => { :user_id => user.id, :role => "owner" }
      can :destroy, Venue, :user_venue_managements => { :user_id => user.id, :role => :owner }
      can :create, Venue

      can :create, VenueImage, :venue => { :user_venue_managements => { :user_id => user.id, :role => "manager" }}
      can :create, VenueImage, :venue => { :user_venue_managements => { :user_id => user.id, :role => "owner" }}
      can :destroy, VenueImage, :venue => { :user_venue_managements => { :user_id => user.id, :role => "manager" }}
      can :destroy, VenueImage, :venue => { :user_venue_managements => { :user_id => user.id, :role => "owner" }}
    end


    can :refresh, PublicEventsWidget if user.id
 

  end
end
