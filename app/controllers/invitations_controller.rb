class InvitationsController < ApplicationController
  respond_to :html

  # Does not need authentication
  skip_before_filter :authenticate_user!

  # Does not need authorisation
  check_authorization :except => :token

  load_and_authorize_resource

  def update
    @invitation = Invitation.find params[:id] 
    @invitation.update_attributes params[:invitation]
    redirect_to edit_event_path(@invitation.event)
  end

  def token
    @invitation = Invitation.where{token==my{params[:id]}}.first
    unless @invitation
      raise ActiveRecord::RecordNotFound
    end
    sign_in @invitation.user
    redirect_to edit_event_path(@invitation.event)
  end
end
