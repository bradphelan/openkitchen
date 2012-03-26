module DelayedPaperclip

  class << self
    def detect_background_task
      return DelayedPaperclip::Jobs::GirlFriday
    end
  end

  module Jobs

    class GirlFriday

      Queue = LazyWorkQueue.define :delayed_paperclip, :size => 3 do |info|
        DelayedPaperclip.process_job info[:instance_klass], 
          info[:instance_id], 
          info[:attachment_name]
      end

      def self.enqueue_delayed_paperclip(instance_klass, instance_id, attachment_name)
        Queue.push :instance_klass => instance_klass,
          :instance_id => instance_id,
          :attachment_name => attachment_name
      end
        
    end
  end
end
