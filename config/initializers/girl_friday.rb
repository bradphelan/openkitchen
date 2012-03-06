EMAIL_QUEUE = GirlFriday::WorkQueue.new(:email_queue, :size => 3) do |info|
  QueueDeliveryMethod.unmarshal_email(info[:email]).deliver
end
