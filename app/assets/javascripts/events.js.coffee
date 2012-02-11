# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready =>
  $(".guest_buttons input.remove").tooltip()
  $(".guest_buttons input.email").tooltip()

  $('#google_map').on 'shown', =>
    $("#map").height $("#map").parent().parent().height() - 80
    $("#map").width $("#map").parent().parent().width() - 10

    $("#map").parent().height $("#map").parent().parent().height()
    $("#map").parent().width $("#map").parent().parent().width()

    google.maps.event.trigger(Gmaps.map.map, 'resize')
    Gmaps.map.adjustMapToBounds()
    console.log 'done'

  $("#event_description_editor a.show").popover
    title: "HTML"
    content: "Update event to refresh"

  $('.markdown_popover').popover
    html: true
    title: "Markdown"
    content: """
    <div class="markdown_popover_content">
      <div class="row">
        <div class="span1">*emphasizied*</div>
        <div class="span1"><i>emphasized</i></div>
      </div>

      <div class="row">
        <div class="span1">**bold**</div>
        <div class="span1"><b>bold</b></div>
      </div>

      <div class="row">
        <div class="span1"># (H1)</div>
        <div class="span1"><h1>(H1)</h1></div>
      </div>

      <div class="row">
        <div class="span1">## (H2)</div>
        <div class="span1"><h2>(H2)</h2></div>
      </div>

      <div class="row">
        <div class="span3">[Link to google](http://google.com)</div>
        <div class="span3"><a href="http://google.com">Link to google</a></div>
      </div>

    </div>

    """
