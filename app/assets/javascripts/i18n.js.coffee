$(document).ready =>

  show_missing_translations = =>
    $(".translation_missing").tooltip('show')


  window.setTimeout show_missing_translations, 1000
    
