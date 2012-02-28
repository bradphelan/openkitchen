$(document).ready =>
  $('body').on 'click', 'a[data-popup]', ->
    window.open $(@).attr('href'), 600, 300
    false
