$(document).ready =>
  $("body").scrollspy
    offset: 175

  # There is something kooky going on in chrome where I have
  # to refresh the scrollspy plugin after page load otherwise
  # the offsets it calculates are all wrong. GRRRR
  refresh_scollspy = =>$("body").scrollspy("refresh")
  window.setTimeout refresh_scollspy, 500


  # Do nice scrolly effect when we click on the sub-nav bar
  goToByScroll = (id, offset) ->
    finaloffset = $(id).offset().top + offset
    currentoffset = $("body").scrollTop()

    animate = (speed, complete=null)->
      finaloffset = $(id).offset().top + offset
      $("html,body").animate scrollTop: finaloffset, speed, complete

    animate "slow", =>
      # scrollspy is flakey. Safer to refresh it after
      # the screen jiggles around
      refresh_scollspy()
      animate "fast"
          

  # Need to refresh the scroll spy after AJAX handlers
  $("body").ajaxComplete => refresh_scollspy()

  $(".subnav").on "click", "a", ->
    id = $(this).attr("href")
    offset = parseInt $(id).attr('data-offset')
    offset = if isNaN(offset) then 0 else offset
    o = $("#subnavbar ul").outerHeight()
    oo = $("#navbar .container").outerHeight()

    # Is the subnavbar in fixed or expanded mode. If
    # in expanded mode we don't need the offset. It's
    # still not a perfect check but better than nix.
    if o < 100
      delta = o + oo
    else
      delta = 0
    goToByScroll id, -delta + offset
    false

  #
  # Scroll magic to fix the subnavbar to 
  # below the header
  #
  $win = $(window)
  $nav = $(".subnav")
  $nav_pad = $("#subnavbar_padding")
  navTop = $(".subnav").length and $(".subnav").offset().top - 40
  isFixed = 0
  processScroll = ->
    i = undefined
    scrollTop = $win.scrollTop()
    if scrollTop >= navTop and not isFixed
      isFixed = 1
      $nav.addClass "subnav-fixed"
      $nav_pad.height($nav.height())
    else if scrollTop <= navTop and isFixed
      isFixed = 0
      $nav.removeClass "subnav-fixed"
      $nav_pad.height(0)
  processScroll()
  $win.on "scroll", processScroll
  
$(document).ready =>
  template = (id, label) =>
    """
    <li>
      <a href="##{id}">
        #{label}
      </a>
    </li>
    """

  menu_items = $('[data-subnav-label]')
  if menu_items.length == 0
    $("header#overview #subnavbar").hide()
    $("section.scrollbuffer").hide()
    return

  menu_items.each (i,v)=>
    id = $(v).attr("id")
    label = $(v).attr("data-subnav-label")
    t = template(id, label)
    $(".subnav ul.nav").append t
