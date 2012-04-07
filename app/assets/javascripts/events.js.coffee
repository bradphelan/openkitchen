# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready =>

	container = $(".events > .list")
	detector = container.children().first().next()
	curWidth = detector.outerWidth(true)
	container.imagesLoaded =>

		detect = =>
			if detector.outerWidth(true)!=curWidth
				curWidth = detector.outerWidth(true)
				container.masonry()

		$(window).resize =>
			detect()

		container.masonry
			itemSelector: ".span3"
			isAnimated: true

			animationOptions:
				duration: 400
				complete: (e)->
					if @ == container[0]
						detect()
						console.log e, @



