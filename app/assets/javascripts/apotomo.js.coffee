$(document).ready =>

  rootWidget = (leaf)=>
    leaf.parents(".widget").last()

  apply = =>

    $('body').on 'ajax:before', '*',  (e)->

      target = $(@)
      e.stopPropagation()

      # Only the root widget has state 
      # parameters
      widget = rootWidget(target)

      state = widget.data 'state'
      id = widget.attr 'id'
      params = target.data('params')
      params = {} unless params?
      params['state'] = {}
      params['state'][id] = state

      target.data('params', params)

  apply()
