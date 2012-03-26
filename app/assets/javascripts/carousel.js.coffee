class ImageLoader
  @setup : ->
      $(".carousel_nav img").error (e)->
        console.log "Error trigger for"
        console.log $(@)
        new ImageLoader $(@)


  constructor: (@elem)->
    @elem.hide()
    @timeout()

  timeout: ->
    window.setTimeout ( => @check() ), 1000

  check: ->
    @elem.show()
    src = @elem.attr 'src'
    @elem.attr 'src', src

# Do nice scrolly effect when we click on the sub-nav bar
goToByScroll = (id) ->
  strip = id.closest(".strip")
  finaloffset = id.position().left + strip.scrollLeft()

  animate = (speed, complete=null)->
    strip.animate scrollLeft: finaloffset, speed, complete

  animate "slow"

$(document).ready =>

  apply = =>

    nav = $(".carousel_nav")
    strip = nav.find(".strip")
    caro = nav.find(".carousel")

    $("body").on "click", ".carousel_nav a.item", (e) =>
      a = $(e.target).closest("a")
      index = a.index()
      widget = a.closest(".widget")
      caro = widget.find(".carousel")
      widget.find("a").removeClass("active")
      a.addClass("active")
      caro.carousel(index)
      caro.carousel("pause")
      false

    markActive = (carousel)=>
      active = carousel.find(".active")
      id = active.attr('data-image_id')
      widget = active.closest(".widget")
      widget.find("a").removeClass("active")
      active = widget.find(".strip [data-image_id=#{id}]")
      active.addClass("active")
      goToByScroll active

    $("body").on "slid", ".carousel", (e) =>
      markActive($(e.target))


    markActive($(".carousel"))

    $(document).ajaxStop =>
      markActive($(".carousel"))


    $(document).ajaxStop ->
      ImageLoader.setup()


  window.setTimeout apply, 500


  $("body").on "click", "fieldset.fake_file_field a.clicker", (e)=>
    fieldset = $(e.target).closest("fieldset")
    fieldset.find("[type=file]").click()
    false

  $("body").on "change", "fieldset.fake_file_field [type=file]", (e)=>
    fieldset = $(e.target).closest("fieldset")
    fieldset.closest("form").submit()
    true

carouselFunction = $.carousel

