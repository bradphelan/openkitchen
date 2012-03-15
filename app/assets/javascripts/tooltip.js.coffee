$(document).ready =>

  setuptips = =>
    $('[data-tooltip]').tooltip()
    $('a[title]').tooltip()

  $("html").ajaxComplete ->
    $(".tooltip").remove()
    setuptips()

  setuptips()
