# 
# Automagically resize fonts to fit the width of the 
# container they are in as much as possible. 
#
fixfonts = ->
    
  scaler = 1.2

  for element in $('.autofont')

    maxSize = $(element).data('max-font-size') || 100 # px
    minSize = $(element).data('min-font-size') || 10 # px
    
    size = minSize
    element = $(element)
    desired_width = $(element).width()
    banner_height = maxSize || 150
    white_space = "nowrap"

    resizer = $(element.clone())
    resizer.css
      'font-size': "#{size}px"
      'max-width': desired_width
      'display': 'inline'
      'width': 'auto'
      'white-space': white_space
    resizer.insertAfter(element)

    match = false
    while resizer.width() < desired_width and size < banner_height
      match = true
      size = size * scaler
      resizer.css
        'font-size':  "#{size}px"

    unless match
      white_space = "normal"

    newSize = size/scaler

    $(element).css
        'white-space': white_space
        'font-size': "#{newSize}px"
        'line-height': "#{newSize * 1.5}px"

    # Ensure any inline images are also scaled
    # so that they don't mess up the flow.
    element.find("img").height(newSize*1.6)
    element.find("img").width("auto")

    if match
      $(element).css
        'height': "#{newSize * 1.5}px"
    else
      $(element).css
        'height': "auto"
        'line-height': "#{newSize}px"

    resizer.remove()

$(document).ready =>
  fixfonts()

  timeout = 0
  doresize = ->
    timeout--
    if timeout == 0
      fixfonts()

  $(window).resize ->
    timeout++
    window.setTimeout doresize, 200
