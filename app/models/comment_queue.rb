CommentQueue = LazyWorkQueue.define :comment_queue, :size => 3 do |info|
  CommentMailer.mail_subscribers! info[:id]
end
