$(document).ready =>
  $("#loading").ajaxStart ->
    $(@).show()
  $("#loading").ajaxStop ->
    $(@).hide()
  $("#loading")
