if navigator.geolocation

  jQuery.geolocate = (cb)=>

    successFn = (position)->
      cb(position)

    errorFn = (error)->
      (error) ->
          switch error.code
            when error.TIMEOUT
              console.log "Geo::Timeout"
            when error.POSITION_UNAVAILABLE
              console.log "Geo::Position unavailable"
            when error.PERMISSION_DENIED
              console.log "Geo::Permission denied"
            when error.UNKNOWN_ERROR
              console.log "Geo::Unknown error"

    navigator.geolocation.getCurrentPosition successFn, errorFn,
      timeOut: 10 * 1000 * 1000
      enableHighAccuracy: false
      maximumAge: 0

else
  console.log "Geolocation is not supported by this browser"


add_href_params = (selector, new_params)=>
  $(selector).each (index, anchor)=>
    href = $(anchor).attr("href")
    [url, params] = href.split '?'
    params = params.split '&'
    for k,v of new_params
      params.push "#{escape(k)}=#{escape(v)}"
    params = params.join '&'
    href = "#{url}?#{params}"
    $(anchor).attr("href", href)

# Unobtrusively add Geolocation information to anchor elements
# that need it.
geolocate = (cb = null)=>
  $.geolocate (location)=>
    add_href_params "a[data-href-geolocate=true]",
      latitude: location.coords.latitude
      longitude: location.coords.longitude

    if cb?
      cb()

#
# When geo locate is done find all marked anchors
# and execute thier href
#
georefresh = =>
    $("a[data-trigger-on-geolocate=true]").each (index, anchor)=>
      $.post($(anchor).attr("href"))

$(document).ready =>
  geolocate =>
    georefresh()

$(document).ajaxComplete ->
  geolocate()


