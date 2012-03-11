$(document).ready =>

  hide_missing_translations = =>
    $(".translation_missing").tooltip('hide')

  show_missing_translations = =>
    $(".translation_missing").tooltip('show')
    window.setTimeout hide_missing_translations, 1000



  window.setTimeout show_missing_translations, 1000
    
