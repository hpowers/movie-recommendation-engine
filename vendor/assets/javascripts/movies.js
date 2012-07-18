// 
// YouTube iFrame API 
//

// loads the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = "http://www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

var player = '';
function onYouTubePlayerAPIReady() {
  player = new YT.Player('player', {
    events: {
      'onReady': onPlayerReady,
      'onStateChange': onPlayerStateChange
    }
  });
}

// The API will call this function when the video player is ready.
function onPlayerReady(event) {
  event.target.setPlaybackQuality('hd720');
}

//    The API calls this function when the player's state changes.
//    The function indicates that when playing a video (state=1),
//    the player should play for six seconds and then stop.
// var done = false;
function onPlayerStateChange(event) {
  if (event.data == YT.PlayerState.BUFFERING) {
    event.target.setPlaybackQuality('hd720');
  }
}
function stopVideo() {
  player.stopVideo();
}

function playVideo() {
  player.playVideo();
}

//
// END YouTube iFrame API
//

$(document).ready(function() {

  // Objects
  info = $('#info');
  showtimes = $('#showtimes');
  recommendation = $('#recommendation');
  recommendation_title = $('#recommendation h1');
  recommendation_title_span = $('#recommendation h1 span');
  status_message = $('#recommendation h3');
  about_the_movie = $('#about_the_movie');
  theaters_zip = $('#theaters_zip');
  zip_form = $('.zip_form');
  zip_form_input = $('.zip_form input')
  arrow = $('.arrow');
  desktop_trailer = $('#desktop_trailer');
  theaters = $('#theaters');

  // call jRespond and add breakpoints
  var jRes = jRespond([
      {
          label: 'handheld',
          enter: 0,
          exit: 490
      },{
          label: 'desktop',
          enter: 491,
          exit: 10000
      }
  ]);

  // register enter and exit functions for a single breakpoint
  jRes.addFunc({
      breakpoint: 'handheld',
      enter: function() {
        info.click(function(event) {
          about_the_movie.slideToggle();
          recommendation.toggleClass('pointer');
          return false;
        });
        showtimes.click(function(event) {
          var zipcode = prompt("What is your zip code?");
          theaters_zip.val(zipcode);
          zip_form.submit();
          return false;
        });

        recommendation.click(function(event) {
          about_the_movie.slideToggle();
          recommendation.toggleClass('pointer');
          return false;
        });

        mobileTitle();
      },
      exit: function() {
          // remove bindings for desktop
          info.unbind();
          showtimes.unbind();
          recommendation.unbind();
      }
  });

  jRes.addFunc({
      breakpoint: 'desktop',
      enter: function() {
        // resize title, adjust layout and bind to resize
        title();
        $(window).resize(function() { title(); });

        arrow.hover(function() {
          status('I don\'t want to see ...');
        });

        zip_form.hover(function() {
          status('get showtimes for ...');
          zip_form_input.toggleClass('hover');
        });

        zip_form.click(function(event) {
          zip_form.unbind("hover");
          theaters_zip.attr('placeholder', 'ZIP')
          status('enter your zip code to get showtimes for ...');
        });

        var zip_starting_val = zip_form.val();

        // submit form when zip code is entered
        theaters_zip.bind('keyup blur change paste', function() {
          if (theaters_zip.val().length==5 && theaters_zip.val()!=zip_starting_val) {
            // zip code has validated, make some visible changes on page to signify
            theaters_zip.attr("readonly","readonly");
            theaters_zip.css({
              color: '#616161',
              outline: 'none'
            })
            // submit form
            zip_form.submit();
          }
        });

        info.hover(function() {
          status('get more information about ...');
        });

        info.click(function(event) {
          offset = info.offset();

          about_the_movie.css({
             top: offset.top,
            left: offset.left+34
          });

          $('#about_the_movie').toggle();

          // toggles the (i) with (x) on info box
          if (info.text()=="x") {
            info.html('&nbsp;&nbsp;i&nbsp;&nbsp;');
          } else{
            info.text('x');
          };

          return false;
        });

        $('#watch_desktop_trailer a').click(function(event) {
          watch_trailer();
          return false;
        });

        recommendation_title_span.click(function(event) {
          watch_trailer();
          recommendation_title_span.unbind();
          return false;
        });

        recommendation_title_span.hover(function() {
          status('watch a trailer for ...');
        });

        function watch_trailer () {
          $('#about_the_movie').hide();

          if ($('#info').text()=='x') {
            $('#info').html('&nbsp;&nbsp;i&nbsp;&nbsp;');
          };

          player.playVideo();
          desktop_trailer.toggle();
          fixMargin();
        }

      },
      exit: function() {
        $(window).unbind();
        arrow.unbind();
        zip_form.unbind();
        info.unbind();
        recommendation_title_span.unbind();

        recommendation.css('margin-top', 'auto');
        about_the_movie.css('display','none');
        desktop_trailer.css('display','none');

        player.stopVideo();
      }
  });
});


function mobileTitle(){
  var max_width = 310, max_height = 175;

  // set default font size
    var def_font_size = ($(window).height() - $('header').height()) / 6
    recommendation_title.css('font-size',def_font_size+'px');

  while (recommendation_title.width() > max_width || recommendation_title.height() > max_height) {
    var current_size = parseInt(recommendation_title.css('font-size'));
    recommendation_title.css('font-size',(current_size-1)+'px');
  }

  recommendation_title.css('visibility','visible');
}

function title(){
  var max_width = $(window).width() * .90;

  // set default font size
  var def_font_size = ($(window).height() - $('header').height()) / 6
  recommendation_title.css('font-size',def_font_size+'px');

  while (recommendation_title.width() > max_width ||
        recommendation_title.height() > parseInt(recommendation_title.css('line-height'))*2)
  {
    var current_size = parseInt(recommendation_title.css('font-size'));
    if (current_size==90) {break;};

    recommendation_title.css('font-size',(current_size-1)+'px');
  }
  fixMargin();
  recommendation_title.css('visibility','visible');
}

function fixMargin(){
  window_height = $(window).height();
  header_height = $('header').height()

  var margin = ( window_height - $('#recommendation').height() )/2;

  showtime_adjust = 0;
  if (theaters.height()) {
    showtime_adjust = 60;
  };

  margin = margin - header_height - showtime_adjust;

  // trailer formatting
  if (desktop_trailer.css('display')!='none') {
    t_max_width = $(window).width()*.95;

    t_height = window_height * .61;
    t_width = t_height*16/9;

    if (t_width>t_max_width) {
      t_width = t_max_width;
      t_height = t_width * 9/16;
    };

    if (theaters) {
      t_max_height = window_height - header_height - status_message.height() - recommendation_title.height() - theaters.height() - 50;
      if (t_height>t_max_height) {
        t_height = t_max_height;
        t_width = t_height*16/9;
      };
    };

    $('#desktop_trailer iframe').css({
       width: t_width,
      height: t_height
    })

    margin = ( window_height - desktop_trailer.height() - 50 )/2;
    margin = margin - header_height - status_message.height() - info.height();

    if (theaters) {
      margin = margin - theaters.height();
    };
  };

  if (margin < 1) { margin = 20};
  recommendation.css('margin-top', margin+'px');
}

function status(message){

  if (status_message.text()==message) {
    status_message.text('you should see ...');
  } else{
    status_message.text(message);
  };

}

