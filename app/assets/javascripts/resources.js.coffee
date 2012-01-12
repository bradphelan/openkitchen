# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready =>
	$(".resource_quantity_button.up").twipsy
		title: -> "Increase your pledge"
		live: true
		delayOut: 50
		animate: false

	$(".resource_quantity_button.down").twipsy
		title: -> "Decrease your pledge"
		live: true
		delayOut: 50
		animate: false

	# Handle a bug removing the twipsy on AJAX calls
	$("body").on "click", ".resource_quantity_button", =>
    $('.twipsy').remove()
