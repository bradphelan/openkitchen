class InvitationsController < ApplicationController
  respond_to :html

  # Does not need authentication
  skip_before_filter :authenticate_user!

  # Does not need authorisation
  skip_authorization_check :only => :token

  load_and_authorize_resource :except => :token

  def update
    @invitation = Invitation.find params[:id] 
    @invitation.update_attributes params[:invitation]
    redirect_to edit_event_path(@invitation.event)
  end

  def mail
    InviteMailer.invite_email(@invitation).deliver
    flash[:notice] = t("invitation.sent", :name => @invitation.user.name)
    flash.keep
    redirect_to edit_event_path(@invitation.event)
  end

  def destroy
    @invitation.destroy
    flash[:notice] = t("invitation.removed", :name => @invitation.user.name)
    flash.keep
    respond_with @invitation, :location => edit_event_path(@invitation.event)
  end

  def token
    @invitation = Invitation.where{token==my{params[:id]}}.first
    unless @invitation
      raise ActiveRecord::RecordNotFound
    end
    sign_in @invitation.user
    redirect_to event_path(@invitation.event)
  end
end
