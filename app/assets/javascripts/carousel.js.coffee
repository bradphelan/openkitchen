class ImageLoader
  @setup : ->
    $(".carousel_nav img").map (i,e)=>
      new ImageLoader($(e))

  pulse: (start=true)->
    loadCountSpan = @widget.find("span.load-count")
    if start
      if not loadCountSpan.data('pulse')
        pulsar = =>
          loadCountSpan.data('pulse', true)
          loadCountSpan.animate { opacity: 0.5}, =>
            loadCountSpan.animate { opacity: 1}, =>
              if loadCountSpan.data('pulse')
                pulsar()
        pulsar()
    else
      loadCountSpan.data('pulse', false)

  updateLoadingCount: ->
    loading = @widget.find(".strip img[data-loading=true]").length
    loadCountSpan = @widget.find("span.load-count")
    if loading > 0
      loadCountSpan.show()
      @pulse()
    else
      @pulse(false)
      loadCountSpan.hide()
    loadCountSpan.text("processing ... #{loading}")

  constructor: (@elem)->
    @elem.data('image-load', @)
    @widget = @elem.closest(".widget")
    @elem.on "error.xt.image_loader", (e) => @timeout()
    @elem.on "load.xt.image_loader", (e) => @success()

  success: ->
    @elem.fadeIn(500)
    @elem.attr('data-loading', false)
    @elem.attr('image-load', null)
    @elem.off "error.xt.image_loader"
    @elem.off "load.xt.image_loader"
    @updateLoadingCount()

  timeout: ->
    @elem.attr('data-loading', true)
    @updateLoadingCount(@widget)
    @elem.hide()
    window.setTimeout ( => @check() ), 1000

  check: ->
    src = @elem.attr 'src'
    @elem.attr 'src', src

$(document).ajaxStop ->
  ImageLoader.setup()


# Hide ugly file load buttons if marked so
$(document).ready =>

  $("body").on "click", "fieldset.fake_file_field a.clicker", (e)=>
    fieldset = $(e.target).closest("fieldset")
    fieldset.find("[type=file]").click()
    false

  $("body").on "change", "fieldset.fake_file_field [type=file]", (e)=>
    fieldset = $(e.target).closest("fieldset")
    fieldset.closest("form").submit()
    true

class FilmStripCarousel

  constructor: (@elem) ->

    # Attach the instance to the DOM
    $(@elem).data('widget', @)

    @caro = @elem.find(".carousel")
    @strip = @elem.find(".strip")

    if @caro.find(".active").length == 0
      @caro.find(".item").first().addClass("active")

    @setupEvents()

    # Trigger the twitter bootstrap carousel
    @caro.carousel
      pause: 'nohover'
      interval: 1000000
    @caro.carousel('pause')

  goToByScroll: (id) ->
    return unless id.length > 0
    strip = id.closest(".strip")
    finaloffset = id.position().left + strip.scrollLeft()

    animate = (speed, complete=null)->
      strip.animate scrollLeft: finaloffset, speed, complete

    animate "slow"

  click: (e)->
    a = $(e.target).closest("a.item")
    index = a.index()
    @elem.find("a").removeClass("active")
    a.addClass("active")

    console.log "foo"
    console.log @idOfActiveThumb()
    console.log @imageWithId(@idOfActiveThumb())
    console.log @imageWithId(@idOfActiveThumb()).index()

    index=@imageWithId(@idOfActiveThumb()).index()

    # Fix for bug in carousel which refuses
    # to navigate anywhere if none of the
    # children are active
    @fixCarousel()

    @caro.carousel(index)
    false

  idOfActiveThumb: ()->
    active = @strip.find(".active")
    return null unless active.length > 0
    active.attr('data-image_id')

  idOfActiveImage: ()->
    active = @caro.find(".active")
    return null unless active.length > 0
    active.attr('data-image_id')

  imageWithId: (id)->
    @caro.find(".item[data-image_id=#{id}]")

  activeThumb: ()->
    @strip.find("[data-image_id=#{@idOfActiveImage()}]")

  # The bootstrap carousel goes all poo faced if
  # there are no active elements. This just fixes
  # it.
  fixCarousel: ()->
    if @caro.find(".active").length == 0
      @caro.find(".item").first().addClass("active")
    if @strip.find(".active").length == 0
      @strip.find(".item").first().addClass("active")

  makeActiveForId: (id)->
    @strip.find(".item[data-image_id=#{id}]").click()

  markActiveThumb: ->
    @strip.find(".item").removeClass("active")
    active = @activeThumb().addClass("active")
    @goToByScroll active

  setupEvents: ->

    @strip.on "click", "a.item", (e) => @click(e)
    @caro.on "slid", (e) => @markActiveThumb()


    @markActiveThumb($(".carousel_nav"))

  next: ->
    current = @strip.find(".active")
    next = current.next()
    if next.length == 0
      next = @strip.children().first()
    current.removeClass("active")
    next.addClass("active")
    @caro.carousel("next")

  rmActive: ()->
    a = @strip.find(".active")
    b = @caro.find(".active")

    b.animate {opacity: 0.5}
    a.animate {opacity: 0.0}, =>
      rm =  =>
        a.remove()
        b.remove()
      if @strip.children().length > 1
        @next()
        @caro.one 'slid', => 
          rm()
          true
      else
        rm()




$(document).ready =>
  new FilmStripCarousel($(".carousel_nav"))


