# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require "twitter/bootstrap/tooltip" 
$(document).ready =>
	$(".guest_buttons input.remove").tooltip()
	$(".guest_buttons input.email").tooltip()
