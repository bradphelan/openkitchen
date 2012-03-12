$(document).ready =>
  $("html").on "focus", ".select-on-focus", ->
    select = =>
      $(@).select()
    window.setTimeout select, 100
