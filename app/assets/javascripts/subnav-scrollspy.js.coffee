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

    console.log finaloffset
    console.log currentoffset

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

  $(".subnavbar").on "click", "a", ->
    id = $(this).attr("href")
    console.log id
    goToByScroll id, -120
    false

  # Fix the subnav bar to the top when we scroll down
  $(document).scroll ->
    unless $(".subnavbar").attr("data-top")
      return  if $(".subnavbar").hasClass("subnavbar-fixed-top")
      offset = $(".subnavbar").offset()
      $(".subnavbar").attr "data-top", offset.top

    d = $(".subnavbar").attr("data-top") - $(".subnavbar").outerHeight()
    st = $(this).scrollTop()
    # Add some hysterises in so that it doesn't flicker on the
    # boundary. #hack #win
    hysterises = 30
    if d <= st
      $(".subnavbar").addClass "subnavbar-fixed-top"
    else if d > st + hysterises
      $(".subnavbar").removeClass "subnavbar-fixed-top"
