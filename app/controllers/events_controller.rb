class EventsController < ApplicationController
  def index
    @events = current_user.events_as_owner
    render :index
  end

  def new
    Time.zone = current_user.time_zone
    @event = Event.new :owner => current_user, :datetime => Time.zone.now
  end

  def edit
    @event = Event.find params[:id]
    @invitation = current_user.invitations.where{event_id==my{@event.id}}.first
  end

  def invite
    @event = Event.find params[:id]
    @event.invite params[:invite][:email]
    redirect_to edit_event_path(@event)
  end

  def create
    @event = current_user.events_as_owner.create params[:event]
    if @event.valid?
      redirect_to events_path
    else
      render :new
    end
  end

end
