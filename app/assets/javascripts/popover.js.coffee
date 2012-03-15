$(document).ready =>
  pop = =>
    $("a.popover-trigger").popover()

  $(document).ajaxComplete ->
    pop()

  pop()
