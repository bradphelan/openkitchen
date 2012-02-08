class InviteMailer < ActionMailer::Base
  default from: "bbqinvite@xtargets.com"

  def invite_email invitation
    @invitation = invitation
    @host = @invitation.event.owner
    @guest = @invitation.user
    mail(:to => @guest.email, :subject => "BBQ Invitation from #{@host.email}")
  end

end
