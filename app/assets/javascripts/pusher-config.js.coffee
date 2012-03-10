
$(document).ready =>
#   Pusher.log = (message) ->
#    window.console.log message  if window.console and window.console.log

  WEB_SOCKET_DEBUG = true

  $("[data-pusher-channel]").each (i, obj)=>

    obj = $(obj)
    key = obj.attr('data-pusher-key')
    channel_id = obj.attr('data-pusher-channel')
    event = obj.attr('data-pusher-event')

    pusher = new Pusher(key)
    channel = pusher.subscribe(channel_id)

    # Bind the the create
    channel.bind event, (data) ->
      $.post(data.callback)

    #console.log "PUSHER - key: #{key}, channel:#{channel_id}, event:#{event}"
