$(document).ready =>
  $("html").on "change", "input[data-href]", ->
    obj = $(@)
    href = obj.attr('data-href')
    params = {}
    params[obj.attr('data-param')] = obj.val()
    $.post href, params

