EMAIL_QUEUE = GirlFriday::WorkQueue.new(:email_queue, :size => 3) do |info|
  QueueDeliveryMethod.unmarshal_email(info[:email]).deliver
end

COMMENT_QUEUE = GirlFriday::WorkQueue.new(:comment_queue, :size => 3) do |info|
  CommentMailer.mail_subscribers! info[:id]
end

DEVISE_QUEUE = GirlFriday::WorkQueue.new(:devise_queue, :size => 3) do |info|
  DeviseCompletionMailer.complete_action! info
end

INVITE_QUEUE = GirlFriday::WorkQueue.new(:invite_queue, :size => 3) do |info|
  InviteMailer.invite_email(info[:id]).deliver
end
