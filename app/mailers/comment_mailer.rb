class CommentMailer < ActionMailer::Base
  default from: "bbqinvite@xtargets.com"

  def comment_email comment, invitation
    @comment = comment
    @invitation = invitation
    @event = @invitation.event
    mail(:to => @invitation.user.email, 
         :subject => "New comment on event '#{@event.name}' from #{@comment.user.name}",
         :from => "concierge@openkitchen.at" )
  end

end
