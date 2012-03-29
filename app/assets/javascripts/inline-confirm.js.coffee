$(document).ready =>

  $("body").on "click", ".inline-confirm", (e)=>
    t = $(e.target)
    t.hide()

    yn = """
      <div>
        <a class="no" href='#' >no</a>
        &nbsp;
        <a class="yes" href='#'>yes</a>
      </div>
    """
    yn = $(yn)

    yn = yn.insertAfter t
    yn.fadeIn()

    yn.find(".yes").one "click", =>
      console.log "HERE"
      t.removeClass("inline-confirm")
      t.click()
      t.addClass("inline-confirm")
      yn.remove()
      false

    yn.find(".no").one "click", =>
      yn.remove()
      t.show()
      false

    false
