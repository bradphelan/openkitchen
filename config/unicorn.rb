worker_processes 2
timeout 30

preload_app true

before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end

  sleep 1
end

after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis = ENV['REDIS_URI']
    Rails.logger.info('Connected to Redis')
  end


  # Girl Friday Config
  ::COMMENT_QUEUE = GirlFriday::WorkQueue.new(:comment_queue, :size => 3) do |info|
    CommentMailer.mail_subscribers! info[:id]
  end

  ::DEVISE_QUEUE = GirlFriday::WorkQueue.new(:devise_queue, :size => 3) do |info|
    DeviseBackgroundMailer.complete_action(info).deliver
  end

  ::INVITE_QUEUE = GirlFriday::WorkQueue.new(:invite_queue, :size => 3) do |info|
    InviteMailer.invite_email(info[:id]).deliver
  end
end
