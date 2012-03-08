class InviteMailer < ActionMailer::Base
  default from: "concierge@openkitchen.at"

  def self.deliver_invitation invitation
    ActiveRecord::Base.after_transaction do
      InviteQueue.push :id => invitation.id
    end
  end

  def invite_email invitation
    @invitation = Invitation.find invitation
    @host = @invitation.event.owner
    @guest = @invitation.user
    mail(:to => @guest.email, 
         :subject => "OPENKITCHEN Invitation from #{@host.email}",
         :from => "concierge@openkitchen.at" )
  end

end
