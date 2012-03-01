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

    resizer = $(element.clone())
    resizer.css
      'font-size': "#{size}em"
      'max-width': desired_width
      'display': 'inline'
      'width': 'auto'
    resizer.insertAfter(element)

    while resizer.width() < desired_width
      size = size * scaler
      resizer.css
        'font-size':  "#{size}em"

    $(element).css
        'font-size': "#{size / scaler }em"

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
