class QueueDeliveryMethod
  def deliver!(mail)
    EMAIL_QUEUE.push  :email => Marshal.dump( mail )
  end

  def self.unmarshal_email(email_dump)
    mail = Marshal.load(email_dump)
    mail.delivery_method Rails.application.config.mail_queue_outbound_delivery_method
    mail
  end
end
