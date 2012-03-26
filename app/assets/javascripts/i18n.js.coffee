$(document).ready =>

  return

  show_missing_translations = =>
    tr = $(".translation_missing")
    if tr.length > 0
      console.log "Missing translations"
      console.log tr

  $("html").ajaxComplete ->
    show_missing_translations()


  show_missing_translations()
    
