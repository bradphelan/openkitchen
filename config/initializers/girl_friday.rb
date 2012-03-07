
COMMENT_QUEUE = GirlFriday::WorkQueue.new(:comment_queue, :size => 3) do |info|
  CommentMailer.mail_subscribers! info[:id]
end

DEVISE_QUEUE = GirlFriday::WorkQueue.new(:devise_queue, :size => 3) do |info|
  DeviseBackgroundMailer.complete_action(info).deliver
end

INVITE_QUEUE = GirlFriday::WorkQueue.new(:invite_queue, :size => 3) do |info|
  InviteMailer.invite_email(info[:id]).deliver
end
