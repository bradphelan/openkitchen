InviteQueue = LazyWorkQueue.define :invite_queue, :size => 3 do |info|
  InviteMailer.invite_email(info[:id]).deliver
end

