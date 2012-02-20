class CommentMailer < ActionMailer::Base
  default from: "bbqinvite@xtargets.com"

  
  def self.async_mail_comment comment
    COMMENT_EMAIL_QUEUE << { comment_id: comment.id }
  end

  def self.process_email_queue info
      comment = Comment.find info[:comment_id]
      event = comment.commentable

      event.invitations.each do |invitation|
        if invitation.subscribed_for_comments? and comment.user != invitation.user
          CommentMailer.comment_email(comment, invitation).deliver
        end
      end
       
      puts "XXXXXXXXXXXXXXXXXXXX"
      pp COMMENT_EMAIL_QUEUE.status
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
