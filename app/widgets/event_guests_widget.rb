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

  def invitation i
    render :view => :invitation, :locals => { :invitation => i }
  end

  #
  # Events
  #


  def invite_guest
    authorize! :invite, @event

    if params[:invite] && params[:invite][:email]
      @email = params[:invite][:email] 
    else
      @email = current_user.email
    end

    return unless @email

    if signed_in?
      # Event owner can invite and create users
      invitation = @event.invite_by_email @email, :create => true
      txt = ""
      render_buffer do |b|
        b.replace "##{widget_id}", :view => :display if invitation
        b.replace "section#invite", :text => ""
      end
    elsif @guest = User.find_by_email(@email)
      # Guests with accounts get redirected to sign in
      parent_controller.store_location "#{event_path(@event)}#invite"
      redirect_to new_user_session_path('user[email]' => @email)
    else
      # Guests without accounts can create a non confirmed user
      invitation = @event.invite_by_email @email, :create => true, :public => true, :status => :accepted
      sign_in invitation.user
      flash[:info] = t("event_guests_widget.flash.account_created")
      redirect_to event_path(@event)
    end

  end

end
