class EventsController < ApplicationController
  respond_to :html, :js

  has_widgets do |root|
    root << panel = widget("comments/panel", :comments, :event => @event)
  end
  

  load_and_authorize_resource :except => [:index, :ical, :create, :edit, :render_event_response]

  # Apotomo entry point
  load_resource :only => :render_event_response

  def index
    authorize! :index, Event
    @events_as_owner = current_user.events_as_owner
    @events_as_guest = current_user.events_as_guest.where{owner_id != my{current_user.id}}
    render :index
  end

  def new
    Time.zone = current_user.time_zone
    @event = current_user.build_event_from_profile
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
    @event.gmaps = false
    if @event.update_attributes params[:event]
      flash[:info] = t("event.updated")
      redirect_to edit_event_path(@event)
    else
      flash[:error] = @event.errors.full_messages.to_sentence
      @invitation = current_user.invitations.where{event_id==my{@event.id}}.first

      @map = GoogleStaticMap.new(:zoom => 13, :center => @event.map_location)
      @map.markers << MapMarker.new(:color => "blue", :location => @event.map_location)
      render :edit
    end
  end

  def show
    redirect_to :action => :edit
  end

  def edit
    @event = Event.find params[:id]
    authorize! :read, @event
    @invitation = current_user.invitations.where{event_id==my{@event.id}}.first

    @map = GoogleStaticMap.new(:zoom => 13, :center => @event.map_location)
    @map.markers << MapMarker.new(:color => "blue", :location => @event.map_location)
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
    event.location = @event.gmaps4rails_address
    @calendar.add event
    @calendar.publish
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :layout=>false, :text => @calendar.to_ical

  end

end
