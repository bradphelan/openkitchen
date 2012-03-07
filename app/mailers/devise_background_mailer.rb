class DeviseCompletionMailer < Devise::Mailer
  def make_record info
    info[:type].constantize.find info[:id]
  end
  def complete_action! info
    Rails.logger.info "Completing #{info[:action]} from queue"
    record = make_record info
    devise_mail(record, info[:action].to_sym)
  end
end

class DeviseBackgroundMailer < ActionMailer::Base 

  class Proxy
    def initialize &block
      @block = block
    end
    def deliver
      ActiveRecord::Base.after_transaction do
        @block.call
      end
    end
  end

  def message
    @proxy
  end

  private


  def make_info record, options
    { :type => record.class.to_s,
      :id => record.id
    }.merge(options)
  end


  public

  def proxy &block
    @proxy = Proxy.new &block
  end


  def confirmation_instructions(record)
    proxy do
      Rails.logger.info "Pushing :confirmation_instructions email to queue"
      DEVISE_QUEUE.push make_info(record, :action => :confirmation_instructions)
    end
  end

  def reset_password_instructions(record)
    proxy do
      Rails.logger.info "Pushing :reset_password_instructions email to queue"
      DEVISE_QUEUE.push make_info(record, :action => :reset_password_instructions)
    end
  end

  def unlock_instructions(record)
    proxy do
      Rails.logger.info "Pushing :unlock_instructions email to queue"
      DEVISE_QUEUE.push make_info(record, :action => :unlock_strategy)
    end
  end
end
