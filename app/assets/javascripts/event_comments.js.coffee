removeFade = (t)=>
  $(t).fadeOut 500, =>
    t.remove()

$(document).ready =>
  
  # Destroying comments
  $(".comments").on "ajax:success", ".comment .destroy", (e)=>
    removeFade $(e.target).closest(".comment")
  $(".comments").on "ajax:before", ".comment .destroy", (e)=>
    $(e.target).toggle()
  $(".comments").on "ajax:complete", ".comment .destroy", (e)=>
    $(e.target).toggle()

  $(".comments").on "ajax:success", "form",  (e, response, status)=>
    $(".comments ul").append($(response)).find("li:last-child").hide().fadeIn(1000)
    $(".comments form textarea").val("")

