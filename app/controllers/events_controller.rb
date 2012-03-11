class EventsController < ApplicationController
  respond_to :html, :js


  has_widgets do |root|
    root << panel = widget("comments/panel", :comments, :event => @event)
  end

  has_widgets do |root|
    root << panel = widget(:event_guests, :event => @event )
  end
  

  load_and_authorize_resource :except => [:index, :ical, :create, :render_event_response]

  # Apotomo entry point
  load_resource :only => :render_event_response

  def index
    authorize! :index, Event
    @events_as_owner = current_user.events_as_owner
    @events_as_guest = current_user.events_as_guest.where{owner_id != my{current_user.id}}


    if Rails.env.development?
      @address = Geocoder.search("19a Muensterstrasse, Altmuenster, Austria").first
    else
      @address = request.location
    end

    @radius = params[:radius] || 100

    if @address
      @public_events = Event.near([@address.latitude, @address.longitude], @radius)
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
