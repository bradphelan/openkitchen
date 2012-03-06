class EventGuestsWidget < ApplicationWidget 

  responds_to_event :invite_guest

  #
  # Setup
  #
  has_widgets do
    @event = options[:event]
    @invitation = @event.invitation_for_user current_user
  end

  def display
    render
  end

  def invitation i
    render :view => :invitation, :locals => { :invitation => i }
  end
  #
  # Events
  #

  def invite_guest
    authorize! :invite, @event
    @invitation = @event.invite params[:invite][:email]
    replace "##{widget_id}", :view => :display
  end

end
