class CommentMailer < ActionMailer::Base
  default from: "concierge@xtargets.com"

  
  def self.mail_subscribers comment
    ActiveRecord::Base.after_transaction do
      CommentQueue.push :id => comment.id
    end
  end

  def self.mail_subscribers! comment_id
      comment = Comment.find comment_id
      commentable = comment.commentable

      subscriptions = commentable.commentable_subscriptions.where{subscribed==true}

      subscriptions.each do |subscription|
        if comment.user != subscription.user
          CommentMailer.comment_email(comment, subscription).deliver
        end
      end
       
  end

  def comment_email comment, subscription
    @comment = comment
    @commentable = comment.commentable
    @subscription = subscription
    @commentable_name = @commentable.class.model_name.human

    mail(:to => @subscription.user.email, 
         :subject => "New comment on #{@commentable_name}/#{@commentable.id}' from #{@comment.user.name}",
         :from => "concierge@openkitchen.at" )
  end

end
