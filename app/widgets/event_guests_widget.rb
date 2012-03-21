class EventGuestsWidget < ApplicationWidget 

  responds_to_event :register_any_email_for_event
  responds_to_event :register_non_existing_user_for_event
  responds_to_event :register_current_user_for_event
  responds_to_event :remove_user_for_event

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


  #
  # Events
  #


  def remove_user_for_event
    guest_invitation = Invitation.find params[:guest_invitation_id]
    authorize! :destroy, guest_invitation
    guest_invitation.destroy

    render_buffer do |b|
      b.replace "##{widget_id}", :state => :display

    end

  end

  def register_current_user_for_event
    authorize! :register_current_user_for_event, @event
    if @event.public_seats_left > 0
      invitation = @event.invite current_user, :public => true, :status => :accepted
      render_buffer do |b|
        b.replace "##{widget_id}", :view => :display
        b.replace "section#invite", :text => ""
      end
    else
      render :text => "alert('Unauthorized');"
    end
  end

  def register_non_existing_user_for_event
    authorize! :register_non_existing_user_for_event, @event
    if @event.public_seats_left > 0

      email = params[:invite][:email] 
      if guest = User.find_by_email(email)

        # Guests with accounts get redirected to sign in
        parent_controller.store_location event_path(@event)
        redirect_to new_user_session_path('user[email]'=>email)
      else

        # Guests without accounts can create a non confirmed user
        @guest = User.find_or_create_by_email @email
        invitation = @event.invite @guest, :public => true, :status => :accepted
        sign_in invitation.user
        flash[:info] = t("event_guests_widget.flash.account_created")
        redirect_to event_path(@event)
      end
    else
      render :text => "alert('Unauthorized');"
    end
  end

  def register_any_email_for_event
    authorize! :register_any_email_for_event, @event

    guest_id = params[:invite][:guest_id]

    guest = @event.owner.friends.where{id==guest_id}.first

    unless guest
      return unless params[:invite][:guest]
      guest = @event.owner.friends.find_or_create_by_email params[:invite][:guest] 
    end

    # Event owner can invite and create users
    invitation = @event.invite guest

    render_buffer do |b|
      b.replace "##{widget_id}", :view => :display
      b.render :text => %Q%
        $("input[name='invite[guest]']").focus();
      %

    end

  end

end
