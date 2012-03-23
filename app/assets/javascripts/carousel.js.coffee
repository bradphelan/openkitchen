$(document).ready =>

  apply = =>

    nav = $(".carousel_nav")
    strip = nav.find(".strip")
    caro = nav.find(".carousel")

    strip.on "click", "a.item", (e)=>
      a = $(e.target).closest("a")
      index = a.index()
      console.log index
      caro.carousel(index)
      false


  apply()
