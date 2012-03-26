$(document).ready =>

  apply = =>

    nav = $(".carousel_nav")
    strip = nav.find(".strip")
    caro = nav.find(".carousel")

    $("body").on "click", ".carousel_nav a.item", (e) =>
      a = $(e.target).closest("a")
      index = a.index()
      widget = a.closest(".widget")
      caro = widget.find(".carousel")
      widget.find("a").removeClass("active")
      a.addClass("active")
      caro.carousel(index)
      false

    markActive = (carousel)=>
      active = carousel.find(".active")
      id = active.attr('data-image_id')
      widget = active.closest(".widget")
      widget.find("a").removeClass("active")
      widget.find(".strip [data-image_id=#{id}]").addClass("active")

    $("body").on "slid", ".carousel", (e) =>
      markActive($(e.target))


    markActive($(".carousel"))

    $(document).ajaxStop =>
      markActive($(".carousel"))

  window.setTimeout apply, 500



  fakeFileSet = $("fieldset.fake_file_field")
  $("body").on "click", "fieldset.fake_file_field a.clicker", (e)=>
    fieldset = $(e.target).closest("fieldset")
    fieldset.find("[type=file]").click()
    false

  $("body").on "change", "fieldset.fake_file_field [type=file]", (e)=>
    fieldset = $(e.target).closest("fieldset")
    fieldset.closest("form").submit()
    true

carouselFunction = $.carousel

