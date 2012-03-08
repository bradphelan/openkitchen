class CommentMailer < ActionMailer::Base
  default from: "concierge@xtargets.com"

  
  def self.mail_subscribers comment
    ActiveRecord::Base.after_transaction do
      CommentQueue.push :id => comment.id
    end
  end

  def self.mail_subscribers! comment_id
      comment = Comment.find comment_id

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
