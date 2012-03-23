$(document).ready =>

  setuptips = =>
    $('[data-tooltip]').tooltip()
    $('a[title]').tooltip()
    $('img[title]').tooltip()
    $('i[title]').tooltip()

  $("html").ajaxComplete ->
    $(".tooltip").remove()
    setuptips()

  setuptips()
