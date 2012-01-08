class InvitationsController < ApplicationController
  respond_to :html

  def token
    @invitation = Invitation.where{token==my{params[:id]}}.first
    unless @invitation
      raise ActiveRecord::RecordNotFound
    end
    sign_in @invitation.user
    redirect_to edit_event_path(@invitation.event)
  end
end
