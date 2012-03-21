# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.

# Note we require underscore.js and jquery as depenedencies of course

(($, window) ->
  # window is passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  pluginName = 'genericTypeahead'
  document = window.document
  defaults =
    source: []
    items: 10
    matchBy: (item) => item
    sortBy: (item) => item
    findBy: (item) => item
    label: (item) => item
    item: '<li><a href="#"></a></li>'
    menu: '<ul class="typeahead dropdown-menu"></ul>'

  # The actual plugin constructor
  class GenericTypeahead
    constructor: (element, options) ->
      # jQuery has an extend method which merges the contents of two or
      # more objects, storing the result in the first object. The first object
      # is generally empty as we don't want to alter the default options for
      # future instances of the plugin
      @options = $.extend {}, defaults, options
      @element = $(element)

      @_defaults = defaults
      @_name = pluginName

      @init()

    init: ->
      # Place initialization logic here
      # You already have access to the DOM element and the options via the instance,
      # e.g., this.element and this.options
      @source = @options['source']
      @$menu = $(@options.menu).appendTo('body')
      @shown = false
      @listen()

    show: ->
      pos = $.extend {}, @element.offset(), height: @element[0].offsetHeight
      @$menu.css
        top: pos.top + pos.height
        left: pos.left

      @$menu.show()
      @shown = true
      @

    hide: ->
      @$menu.hide()
      @shown = false

    lookup: (event)->
      @query = @element.val()
      if !@query
        return if @shown then @hide() else @

      items = (item for item in @source when @match(item))

      if !items.length
        return if @shown then @.hide() else @

      items = items.slice(0, @options.items)
      @render(items).show()


    match: (item)->
      ~@options.matchBy(item).toLowerCase().indexOf(@query)

    sort: (items)->
      _.sortBy items, @options.sortBy

    highlight: (item) ->
      pattern = ///#{@query}///ig
      @options.label(item).replace pattern, ($1, match)=>
        return "<strong>" + $1 + "</strong>"

    render: (items)->
      item_elements = _.map items, (item)=>
        item_element = $(@options.item).attr 'data-value', @options.findBy(item)
        item_element.find('a').html(@highlight item)
        item_element[0]

      @$menu.html(item_elements)
      @

    next: (event)->
      active = @$menu.find('.active').removeClass('active')
      next = active.next()
      if !next.length
        next = $(@$menu.find('li')[0])

      next.addClass 'active'

    prev: (event)->
      active = @$menu.find('.active').removeClass('active')
      prev = active.prev()

      if !prev.length
        prev = @$menu.find('li').last()

      prev.addClass 'active'

    listen: ()->
      @.element.on 'blur', (e)=> @blur(e)
      @.element.on 'keypress', (e)=> @keypress(e)
      @.element.on 'keyup', (e)=> @keyup(e)

      if $.browser.webkit || $.browser.msie
        @element.on 'keydown', (e)=> @keypress(e)

      @$menu.on 'click', (e)=> @click(e)
      @$menu.on 'mouseenter', 'li', (e)=> @mouseenter(e)


    keyup: (e)->
      switch e.keyCode
        when 40, 38 # up/down arrow
          null
        when 9, 13 # tab / enter
          return unless @shown
          @select()
        when 27 # esc
          return unless @shown
          @hide()
        else
          @lookup()

    keypress: (e)->
      return unless @shown

      switch e.keyCode
        when 9, 13, 27 # tab/enter/escape
          e.preventDefault()
        when 38 # up arrow
          @prev()
        when 40 # down arrow
          @next()

    blur: (e)->
      window.setTimeout (=> @hide), 150

    click: (e)->
      e.stopPropagation()
      e.preventDefault()
      @select()

    select: ()->
      key = @$menu.find('.active').attr('data-value')
      if key?
        val = _.find @source, (obj)=>
          objKey = @options.findBy(obj)
          objKey == key or objKey == parseInt(key)

        @element.attr('data-value', key)
        @element.val(@options.label(val))

        resultInputName = @element.attr('data-result-input-name')
        if resultInputName?
          @element.closest("form").find("[name='#{resultInputName}']").val(key)

        @element.change()
      @hide()

    mouseenter: (e)->
      @$menu.find('.active').removeClass 'active'
      $(e.currentTarget).addClass 'active'


  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(this, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new GenericTypeahead(@, options))
)(jQuery, window)
