# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready =>
	$(".resource_quantity_button.up").tooltip
		title: -> "Increase your pledge"
		delay: 50
		animation: false

	$(".resource_quantity_button.down").tooltip
		title: -> "Decrease your pledge"
		delay: 50
		animation: false

	# Handle a bug removing the twipsy on AJAX calls
	$("body").on "click", ".resource_quantity_button", =>
    $('.tooltip').remove()
