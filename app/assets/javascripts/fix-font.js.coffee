# 
# Automagically resize fonts to fit the width of the 
# container they are in as much as possible. 
#
fixfonts = ->
    
  scaler = 1.2

  for element in $('.autofont')
    
    size =  1
    element = $(element)
    desired_width = $(element).width()
    banner_height = 150

    resizer = $(element.clone())
    resizer.css
      'font-size': "#{size}px"
      'max-width': desired_width
      'display': 'inline'
      'width': 'auto'
    resizer.insertAfter(element)

    while resizer.width() < desired_width and size < banner_height
      size = size * scaler
      resizer.css
        'font-size':  "#{size}px"

    $(element).css
        'font-size': "#{size / scaler }px"

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
