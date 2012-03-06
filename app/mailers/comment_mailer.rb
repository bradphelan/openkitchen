class CommentMailer < ActionMailer::Base
  default from: "concierge@xtargets.com"

  
  def self.mail_subscribers comment
      event = comment.commentable

      event.invitations.each do |invitation|
        if invitation.subscribed_for_comments? and comment.user != invitation.user
          CommentMailer.comment_email(comment, invitation).deliver
        end
      end
       
  end

  def comment_email comment, invitation
    @comment = comment
    @invitation = invitation
    @event = @invitation.event
    mail(:to => @invitation.user.email, 
         :subject => "New comment on event '#{@event.name}' from #{@comment.user.name}",
         :from => "concierge@openkitchen.at" )
  end

end
