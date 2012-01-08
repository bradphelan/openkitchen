class InvitationsController < ApplicationController
  respond_to :html

  skip_before_filter :authenticate_user!

  def token
    @invitation = Invitation.where{token==my{params[:id]}}.first
    unless @invitation
      raise ActiveRecord::RecordNotFound
    end
    sign_in @invitation.user
    redirect_to edit_event_path(@invitation.event)
  end
end
