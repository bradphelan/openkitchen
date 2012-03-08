require 'pusher'

PusherBaseQueue = LazyWorkQueue.define :pusher_queue, :size => 3 do |info|
  Pusher[info[:channel]].trigger! info[:event], info[:data]
end

class PusherQueue < PusherBaseQueue
  def self.trigger!(channel, event, data = {})
    ActiveRecord::Base.after_transaction do
      push :channel => channel, :event => event, :data => data
    end
  end
end
