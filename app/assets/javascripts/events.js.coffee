# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready =>

  # TODO remove this code
  return false

  $(".guest_buttons input.remove").tooltip()
  $(".guest_buttons input.email").tooltip()

  $('#google_map').on 'shown', =>
    $("#map").height $("#map").parent().parent().height() - 80
    $("#map").width $("#map").parent().parent().width() - 10

    $("#map").parent().height $("#map").parent().parent().height()
    $("#map").parent().width $("#map").parent().parent().width()

    google.maps.event.trigger(Gmaps.map.map, 'resize')
    Gmaps.map.adjustMapToBounds()
    console.log 'done'

  $("#event_description_editor a.show").popover
    title: "HTML"
    content: "Update event to refresh"

