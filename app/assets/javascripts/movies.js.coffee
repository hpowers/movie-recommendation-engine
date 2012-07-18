tag = document.createElement("script")
tag.src = "http://www.youtube.com/player_api"
firstScriptTag = document.getElementsByTagName("script")[0]
firstScriptTag.parentNode.insertBefore tag, firstScriptTag


player = undefined
window.onYouTubePlayerAPIReady = ->
  console.log('this is a test')
  player = new YT.Player("player",
    events:
      onReady: onPlayerReady
      onStateChange: onPlayerStateChange
  )

window.onPlayerReady = (event) ->
  event.target.setPlaybackQuality "hd720"
window.onPlayerStateChange = (event) ->
  event.target.setPlaybackQuality "hd720"  if event.data is YT.PlayerState.BUFFERING
stopVideo = ->
  player.stopVideo()
playVideo = ->
  player.playVideo()

jRes = jRespond([
  label: "handheld"
  enter: 0
  exit: 490
,
  label: "desktop"
  enter: 491
  exit: 10000
 ])
$(document).ready ->
  mobileTitle = ->
    max_width = 310
    max_height = 175
    def_font_size = ($(window).height() - $("header").height()) / 6
    recommendation_title.css "font-size", def_font_size + "px"
    while recommendation_title.width() > max_width or recommendation_title.height() > max_height
      current_size = parseInt(recommendation_title.css("font-size"))
      recommendation_title.css "font-size", (current_size - 1) + "px"
    recommendation_title.css "visibility", "visible"
  title = ->
    max_width = $(window).width() * .90
    def_font_size = ($(window).height() - $("header").height()) / 6
    recommendation_title.css "font-size", def_font_size + "px"
    while recommendation_title.width() > max_width or recommendation_title.height() > parseInt(recommendation_title.css("line-height")) * 2
      current_size = parseInt(recommendation_title.css("font-size"))
      break  if current_size is 90
      recommendation_title.css "font-size", (current_size - 1) + "px"
    fixMargin()
    recommendation_title.css "visibility", "visible"
  fixMargin = ->
    window_height = $(window).height()
    header_height = $("header").height()
    margin = (window_height - $("#recommendation").height()) / 2
    showtime_adjust = 0
    showtime_adjust = 60  if theaters.height()
    margin = margin - header_height - showtime_adjust
    unless desktop_trailer.css("display") is "none"
      t_max_width = $(window).width() * .95
      t_height = window_height * .61
      t_width = t_height * 16 / 9
      if t_width > t_max_width
        t_width = t_max_width
        t_height = t_width * 9 / 16
      if theaters
        t_max_height = window_height - header_height - status_message.height() - recommendation_title.height() - theaters.height() - 50
        if t_height > t_max_height
          t_height = t_max_height
          t_width = t_height * 16 / 9
      $("#desktop_trailer iframe").css
        width: t_width
        height: t_height

      margin = (window_height - desktop_trailer.height() - 50) / 2
      margin = margin - header_height - status_message.height() - info.height()
      margin = margin - theaters.height()  if theaters
    margin = 20  if margin < 1
    recommendation.css "margin-top", margin + "px"
  status = (message) ->
    if status_message.text() is message
      status_message.text "you should see ..."
    else
      status_message.text message
  info = $("#info")
  showtimes = $("#showtimes")
  recommendation = $("#recommendation")
  recommendation_title = $("#recommendation h1")
  recommendation_title_span = $("#recommendation h1 span")
  status_message = $("#recommendation h3")
  about_the_movie = $("#about_the_movie")
  theaters_zip = $("#theaters_zip")
  zip_form = $(".zip_form")
  zip_form_input = $(".zip_form input")
  arrow = $(".arrow")
  desktop_trailer = $("#desktop_trailer")
  theaters = $("#theaters")
  jRes.addFunc
    breakpoint: "handheld"
    enter: ->
      info.click (event) ->
        about_the_movie.slideToggle()
        recommendation.toggleClass "pointer"
        false

      showtimes.click (event) ->
        zipcode = prompt("What is your zip code?")
        theaters_zip.val zipcode
        zip_form.submit()
        false

      recommendation.click (event) ->
        about_the_movie.slideToggle()
        recommendation.toggleClass "pointer"
        false

      mobileTitle()

    exit: ->
      info.unbind()
      showtimes.unbind()
      recommendation.unbind()

  jRes.addFunc
    breakpoint: "desktop"
    enter: ->
      watch_trailer = ->
        $("#about_the_movie").hide()
        $("#info").html "&nbsp;&nbsp;i&nbsp;&nbsp;"  if $("#info").text() is "x"
        player.playVideo()
        desktop_trailer.toggle()
        fixMargin()
      title()
      $(window).resize ->
        title()

      arrow.hover ->
        status "I don't want to see ..."

      zip_form.hover ->
        status "get showtimes for ..."
        zip_form_input.toggleClass "hover"

      zip_form.click (event) ->
        zip_form.unbind "hover"
        theaters_zip.attr "placeholder", "ZIP"
        status "enter your zip code to get showtimes for ..."

      zip_starting_val = zip_form.val()
      theaters_zip.bind "keyup blur change paste", ->
        if theaters_zip.val().length is 5 and theaters_zip.val() isnt zip_starting_val
          theaters_zip.attr "readonly", "readonly"
          theaters_zip.css
            color: "#616161"
            outline: "none"

          zip_form.submit()

      info.hover ->
        status "get more information about ..."

      info.click (event) ->
        offset = info.offset()
        about_the_movie.css
          top: offset.top
          left: offset.left + 34

        $("#about_the_movie").toggle()
        if info.text() is "x"
          info.html "&nbsp;&nbsp;i&nbsp;&nbsp;"
        else
          info.text "x"
        false

      $("#watch_desktop_trailer a").click (event) ->
        watch_trailer()
        false

      recommendation_title_span.click (event) ->
        watch_trailer()
        recommendation_title_span.unbind()
        false

      recommendation_title_span.hover ->
        status "watch a trailer for ..."

    exit: ->
      $(window).unbind()
      arrow.unbind()
      zip_form.unbind()
      info.unbind()
      recommendation_title_span.unbind()
      recommendation.css "margin-top", "auto"
      about_the_movie.css "display", "none"
      desktop_trailer.css "display", "none"
      player.stopVideo()
