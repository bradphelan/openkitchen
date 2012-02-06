# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready =>
  wrapper = $('.home #teaser-wrapper')
  if wrapper?
    video_id = wrapper.attr('data-video')

    player = null

    embed_video = =>
      video = wrapper.find(".modal-body")
      video.html """
        <iframe 
             id="teaser" 
             frameborder = "0" 
             height = "534" 
             width = "949"
             src = "http://player.vimeo.com/video/#{video_id}?autoplay=0&api=1
        "/>
      """
      
      player = wrapper.find("iframe")[0]
      $f(player).addEvent 'ready', =>
        alert 'ready'

    embed_video()

    start_video = =>
      $f(player).api("play")

    pause_video = =>
      $f(player).api("pause")

    wrapper.on 'hidden', =>
      pause_video()

    wrapper.on 'shown', =>
      start_video()





