# 
# YouTube iFrame API 
# 

# loads the IFrame Player API code asynchronously.
tag = document.createElement("script")
tag.src = "http://www.youtube.com/player_api"
firstScriptTag = document.getElementsByTagName("script")[0]
firstScriptTag.parentNode.insertBefore tag, firstScriptTag

player = undefined
window.onYouTubePlayerAPIReady = ->
  player = new YT.Player("player",
    events:
      onReady: onPlayerReady
      onStateChange: onPlayerStateChange
  )

# The API will call this function when the video player is ready.
window.onPlayerReady = (event) ->
  event.target.setPlaybackQuality "hd720"

# The API calls this function when the player's state changes.
# The function indicates that when playing a video (state=1),
# the player should play for six seconds and then stop.
window.onPlayerStateChange = (event) ->
  event.target.setPlaybackQuality "hd720"  if event.data is YT.PlayerState.BUFFERING

stopVideo = ->
  player.stopVideo()

playVideo = ->
  player.playVideo()

# mobile detection
isMobile =
  Android: ->
    (if navigator.userAgent.match(/Android/i) then true else false)

  BlackBerry: ->
    (if navigator.userAgent.match(/BlackBerry/i) then true else false)

  iOS: ->
    (if navigator.userAgent.match(/iPhone|iPad|iPod/i) then true else false)

  Windows: ->
    (if navigator.userAgent.match(/IEMobile/i) then true else false)

  any: ->
    isMobile.Android() or isMobile.BlackBerry() or isMobile.iOS() or isMobile.Windows()

# call jRespond and add breakpoints
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
  # resize the title in mobile view
  mobileTitle = ->
    
    # based on iPhone viewport
    max_width = 310
    max_height = 175

    # start at 1/6 of height minus header
    def_font_size = ($(window).height() - $("header").height()) / 6
    recommendation_title.css "font-size", def_font_size + "px"
    
    # drop the font size by 1px, until title fits in constraints
    while recommendation_title.width() > max_width or recommendation_title.height() > max_height
      current_size = parseInt(recommendation_title.css("font-size"))
      recommendation_title.css "font-size", (current_size - 1) + "px"

    # title starts off to prevent "jerkiness" resizing
    recommendation_title.css "visibility", "visible"
  
  # resize the title in desktop view
  title = ->

    max_width = $(window).width() * .90
    def_font_size = ($(window).height() - $("header").height()) / 6
    recommendation_title.css "font-size", def_font_size + "px"
    
    # try to get the width under 90% and keep it to 1 line
    while recommendation_title.width() > max_width or recommendation_title.height() > parseInt(recommendation_title.css("line-height")) * 2
      
      current_size = parseInt(recommendation_title.css("font-size"))
      
      # bottom out at 90px
      break if current_size is 90
      
      recommendation_title.css "font-size", (current_size - 1) + "px"
    
    # update the margin after resizing
    fixMargin()

    # title starts off to prevent "jerkiness" resizing
    recommendation_title.css "visibility", "visible"
  
  # adjust the margins
  fixMargin = ->

    window_height = $(window).height()
    header_height = $("header").height()

    margin = (window_height - $("#recommendation").height()) / 2

    # adjust the margin for showtime information if present 
    showtime_adjust = 0
    showtime_adjust = 60  if theaters.height()
    margin = margin - header_height - showtime_adjust
    
    # if a trailer is visible resize it
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
      
      # update the trailer with the calculated size
      $("#desktop_trailer iframe").css
        width: t_width
        height: t_height

      margin = (window_height - desktop_trailer.height() - 50) / 2
      margin = margin - header_height - status_message.height() - info.height()
      margin = margin - theaters.height()  if theaters
    margin = 20  if margin < 1
    recommendation.css "margin-top", margin + "px"
  
  # This function toggles the status message
  status = (message) ->
    if status_message.text() is message
      status_message.text "you should see ..."
    else
      status_message.text message
  
  # objects for targetting
  info                      = $("#info")
  showtimes                 = $("#showtimes")
  recommendation            = $("#recommendation")
  recommendation_title      = $("#recommendation h1")
  recommendation_title_span = $("#recommendation h1 span")
  status_message            = $("#recommendation h3")
  about_the_movie           = $("#about_the_movie")
  theaters_zip              = $("#theaters_zip")
  zip_form                  = $(".zip_form")
  zip_form_input            = $(".zip_form input")
  arrow                     = $(".arrow")
  desktop_trailer           = $("#desktop_trailer")
  theaters                  = $("#theaters")

  zip_placeholder = 'ZIP'

  # handle a few safari quirks
  if navigator.userAgent.match(/OS X.*Safari/) and not navigator.userAgent.match(/Chrome/)
    # safari doesn't render placeholders well
    zip_placeholder = '           ZIP'
    zip_form_input.css 'line-height', '1'
    # console.log 'safari detected'

    place_val = zip_form.data("place")
    if place_val == "SHOWTIMES"
      zip_form_input.attr 'placeholder', '   SHOWTIMES'
    else
      zip_form_input.attr 'placeholder', '         '+place_val

  # register enter and exit functions for a single breakpoint
  jRes.addFunc
    breakpoint: "handheld"
    enter: ->
      # alert "mobile"
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
      # clean up bindings when switching to desktop
      info.unbind()
      showtimes.unbind()
      recommendation.unbind()

  jRes.addFunc
    breakpoint: "desktop"
    enter: ->
      # mobile safari currently triggers desktop first then mobile
      # alert "desktop"
      watch_trailer = ->
        # insure the info box is in the correct state
        $("#about_the_movie").hide()
        $("#info").html "&nbsp;&nbsp;i&nbsp;&nbsp;"  if $("#info").text() is "x"
        # show the trailer
        desktop_trailer.toggle()
        # update the layout
        fixMargin()
        # start loading in the video file
        wait_for_load = ->
          # make sure the player is ready
          unless typeof player.playVideo is "function"
            setTimeout wait_for_load, 50
            return
          # don't call playVideo on non-mobile devices
          playVideo() if !isMobile.any()
        wait_for_load()
      title()

      # adjust the title if the window is resized
      $(window).resize ->
        title()

      arrow.hover ->
        status "I don't want to see ..."

      zip_form.hover ->
        status "get showtimes for ..."
        zip_form_input.toggleClass "hover"

      zip_form.click (event) ->
        zip_form.unbind "hover"
        theaters_zip.attr "placeholder", zip_placeholder
        status "enter your zip code to get showtimes for ..."

      zip_starting_val = zip_form.val()
      # auto submit zip code form when valid zip is entered
      # and don't submit if zip code is same as code already entered
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
      # clean up bindings when switching to mobile
      $(window).unbind()
      arrow.unbind()
      zip_form.unbind()
      info.unbind()
      recommendation_title_span.unbind()
      recommendation.css "margin-top", "auto"
      about_the_movie.css "display", "none"
      desktop_trailer.css "display", "none"
      # this line bugs out in mobile safari
      # player.stopVideo()
