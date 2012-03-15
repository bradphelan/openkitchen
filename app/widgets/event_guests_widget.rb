class EventGuestsWidget < ApplicationWidget 

  responds_to_event :register_email_for_event
  responds_to_event :register_non_existing_user_for_event
  responds_to_event :register_current_user_for_event

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

  def invitation i
    render :view => :invitation, :locals => { :invitation => i }
  end

  #
  # Events
  #


  def register_current_user_for_event
    authorize! :register_current_user_for_event, @event
    invitation = @event.invite current_user
  end

  def register_non_existing_user_for_event
    authorize! :register_non_existing_user_for_event, @event

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
  end

  def register_email_for_event
    authorize! :register_email_for_event, @event

    email = params[:invite][:email] 

    return unless email

    # Event owner can invite and create users
    guest = User.find_or_create_by_email email
    invitation = @event.invite guest

    render_buffer do |b|
      b.replace "##{widget_id}", :view => :display
      b.replace "section#invite", :text => ""
    end

  end

end
