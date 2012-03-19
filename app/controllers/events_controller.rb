class EventsController < ApplicationController
  respond_to :html, :js


  my_events = proc do |events|
    events.where{owner_id==my{current_user.id}}
  end

  public_events = proc do |events|
    events.where{public==true}
  end

  invited_to_events = proc do |events|
    events.joins{invitations}.where{invitations.user_id==my{current_user.id}}
  end

  has_widgets do |root|
    # For /events/:id
    if params[:id]
      root << widget("comments/panel", :comments, :event => @event, :params => params)
      root << widget(:event_guests, :event => @event )
    else

      # For /events
      if current_user
        root << widget(:public_events , 'my_events'         , :geolocate => false , :filter => my_events         , :title => "as Host")
        root << widget(:public_events , 'invited_to_events' , :geolocate => false , :filter => invited_to_events , :title => "as Guest")
      end

      root << widget(:public_events , 'public_events'     , :geolocate => true  , :filter => public_events     , :title => "Public Events")
    end
  end

  load_and_authorize_resource :except => [:index, :ical, :create, :render_event_response]

  # Apotomo entry point
  load_resource :only => :render_event_response

  skip_before_filter :authenticate_user!, :only => [:index, :render_event_response]

  def index
    authorize! :index, Event
    if signed_in?
      @events_as_owner = current_user.events_as_owner
      @events_as_guest = current_user.events_as_guest.where{owner_id != my{current_user.id}}
    end

    render :index
  end

  def new
    @event = current_user.events_as_owner.build
    @event.venue = current_user.venues.first
    if @event.venue
      @event.timezone = @event.venue.timezone
    end
  end
  

  def create

    authorize! :create, Event

    @event = current_user.events_as_owner.create params[:event]
    if @event.valid?
      # TODO i18n this
      flash[:notice] = "Event '#{@event.name}' has been created"
      redirect_to events_path
    else
      render :new
    end
  end

  def update
    @event.attributes = params[:event]
    authorize! :update, @event
    if @event.save
      flash[:info] = t("event.updated")
      redirect_to edit_event_path(@event)
    else
      flash[:error] = @event.errors.full_messages.to_sentence
      @invitation = current_user.invitations.where{event_id==my{@event.id}}.first

      render :edit
    end
  end

  def  edit
    @invitation = current_user.invitations.where{event_id==my{@event.id}}.first
  end

  skip_before_filter :authenticate_user!, :only => :show, :if => lambda { 
    if params[:id]
      @event = Event.find(params[:id])
      @event and @event.public?
    else
      false
    end
  }
  
  def show
    if current_user
      @invitation = current_user.invitations.where{event_id==my{@event.id}}.first
    end
    @venue = @event.venue
    @map = GoogleStaticMap.new(:zoom => 13, :center => @venue.map_location)
    @map.markers << MapMarker.new(:color => "blue", :location => @venue.map_location)
  end

  def invite
    @invitation = @event.invite params[:invite][:email]
    redirect_to edit_event_path(@event)
  end

  # TODO spec this.
  def ical
    require 'icalendar'
    @event = Event.find params[:id]

    authorize! :read, @event

    @calendar = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.start = @event.datetime.strftime("%Y%m%dT%H%M%S")
    event.end = (@event.datetime+5.hours).strftime("%Y%m%dT%H%M%S")
    event.url = event_url(@event)
    event.summary = @event.name
    event.description = @event.description
    event.location = @event.venue.full_address
    @calendar.add event
    @calendar.publish
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :layout=>false, :text => @calendar.to_ical, :status => :ok

  end

end
