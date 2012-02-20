COMMENT_EMAIL_QUEUE = GirlFriday::WorkQueue.new(:user_email, :size => 3) do |info|
  CommentMailer.process_email_queue info
end
