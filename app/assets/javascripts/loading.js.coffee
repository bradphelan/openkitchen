$(document).ready =>
  $("#loading").ajaxStart ->
    $(@).show()
  $("#loading").ajaxComplete ->
    $(@).hide()
