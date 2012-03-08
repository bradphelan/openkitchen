DeviseQueue = LazyWorkQueue.define :devise_queue, :size => 3 do |info|
  DeviseBackgroundMailer.complete_action(info).deliver
end
