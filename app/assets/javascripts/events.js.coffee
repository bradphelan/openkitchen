# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready =>
	$(".delete_guest_button input").twipsy
		live: true

	$(".send_invitation_button input").twipsy
		live: true
