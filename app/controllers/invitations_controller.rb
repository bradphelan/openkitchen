class InvitationsController < ApplicationController
  respond_to :html

  def token
    @invitation = Invitation.where{token==my{params[:id]}}.first
    unless @invitation
      raise ActiveRecord::RecordNotFound
    end
    sign_in @invitation.user
    redirect_to :action => :edit, :id => @invitation.id
  end
end
