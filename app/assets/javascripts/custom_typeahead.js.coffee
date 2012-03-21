apply = =>

  input = $('[data-provide=genericTypeahead]')
  if input.length
    data = input.data()

    data.matchBy = (item)->
      item['name']

    data.sortBy = (item) ->
      item['name']

    data.findBy = (item)->
      item['id']

    data.label = (item)->
      item['name']


    input.genericTypeahead data

$(document).ready =>
  apply()

$(document).ajaxComplete =>
  apply()
