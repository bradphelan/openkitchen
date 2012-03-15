# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready =>
	# TODO remove this
  return false

	$(".resource_quantity_button.up").tooltip
		title: -> "Increase your pledge"
		delay: 50
		animation: false

	$(".resource_quantity_button.down").tooltip
		title: -> "Decrease your pledge"
		delay: 50
		animation: false

