class EventsController < ApplicationController
  respond_to :html, :js

  has_widgets do |root|
    root << panel = widget("comments/panel", :comments, :event => @event)
  end
  

  load_and_authorize_resource :except => [:index, :create, :edit, :render_event_response]

  # Apotomo entry point
  load_resource :only => :render_event_response

  def index
    authorize! :index, Event
    @events = Set.new(current_user.events_as_owner.all) + Set.new(current_user.events_as_guest.all)
    render :index
  end

  def new
    Time.zone = current_user.time_zone
    @event = Event.new :owner => current_user, :datetime => Time.zone.now
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
    @event.update_attributes params[:event]
    redirect_to edit_event_path
  end

  def edit
    @event = Event.find params[:id]
    authorize! :read, @event
    @invitation = current_user.invitations.where{event_id==my{@event.id}}.first
    @mapping_data = [@event].to_gmaps4rails
  end

  def show
    render :edit
  end

  def invite
    @invitation = @event.invite params[:invite][:email]
    redirect_to edit_event_path(@event)
  end


end
