$(document).ready =>

  $("html").on "keydown", "textarea[data-submit-on-enter]", (e)->
    keyCode = (if e.which then e.which else e.keyCode)
    if (keyCode is 10 or keyCode is 13 and e.ctrlKey)
      val = @value
      if typeof @selectionStart is "number" and typeof @selectionEnd is "number"
        start = @selectionStart
        @value = val.slice(0, start) + "\n" + val.slice(@selectionEnd)
        @selectionStart = @selectionEnd = start + 1
      else if document.selection and document.selection.createRange
        @focus()
        range = document.selection.createRange()
        range.text = "\r\n"
        range.collapse false
        range.select()
      height = $(e.target).height()
      $(e.target).height(height + getLineHeight(e.target))
      false
    else if keyCode is 13

      # submit the form. Rails UJS helpers will
      # pick up the event and handle it as a 
      # remote request
      $(e.target).closest("form").submit()
      false

getLineHeight = (element) ->
  temp = document.createElement(element.nodeName)
  temp.setAttribute "style", "margin:0px;padding:0px;font-family:" + element.style.fontFamily + ";font-size:" + element.style.fontSize
  temp.innerHTML = "test"
  temp = element.parentNode.appendChild(temp)
  ret = temp.clientHeight
  temp.parentNode.removeChild temp
  ret
