# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require "twitter/bootstrap/tooltip" 
#= require "twitter/bootstrap/modal" 
$(document).ready =>
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
