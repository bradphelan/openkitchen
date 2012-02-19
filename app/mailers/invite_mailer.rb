class InviteMailer < ActionMailer::Base
  default from: "concierge@openkitchen.at"

  def invite_email invitation
    @invitation = invitation
    @host = @invitation.event.owner
    @guest = @invitation.user
    mail(:to => @guest.email, 
         :subject => "OPENKITCHEN Invitation from #{@host.email}",
         :from => "concierge@openkitchen.at" )
  end

end
