class EventGuestsWidget < ApplicationWidget 

  responds_to_event :invite_guest

  #
  # Setup
  #
  has_widgets do
    @event = options[:event]
    if @event
      if signed_in?
        @invitation = @event.invitation_for_user current_user
      end
    end
  end

  def display
    render
  end

  cache :invitation do |cell, invitation|
    Rails.logger.info "XXXXXXXXXXXXXXXXXXXXXX"
    Rails.logger.info invitation.class
    Rails.logger.info invitation.to_json
    invitation.updated_at
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
