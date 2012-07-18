// 
// YouTube iFrame API Code
//

// 1. This code loads the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = "http://www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// 2. This function creates an <iframe> (and YouTube player)
//    after the API code downloads.
var player;
function onYouTubePlayerAPIReady() {
  player = new YT.Player('player', {
    playerVars: {
      'modestbranding': 1,
      'rel': 0,
      'showinfo': 0,
      'showsearch': 0,
      'autohide': 1
    },
    events: {
      'onReady': onPlayerReady,
      'onStateChange': onPlayerStateChange
    }
  });
}

// 3. The API will call this function when the video player is ready.
function onPlayerReady(event) {
  // event.target.playVideo();
  event.target.setPlaybackQuality('hd720');
}

// 4. The API calls this function when the player's state changes.
//    The function indicates that when playing a video (state=1),
//    the player should play for six seconds and then stop.
// var done = false;
function onPlayerStateChange(event) {
  // if (event.data == YT.PlayerState.PLAYING && !done) {
  //   setTimeout(stopVideo, 6000);
  //   done = true;
  // }
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
// END YouTube iFrame API Code
//

$(document).ready(function() {

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
        $('#info').click(function(event) {
          // $('#mobile_info').slideToggle();
          // update the about_movie specs
          // slideToggle
          $('#about_the_movie').slideToggle();

          $('#recommendation').toggleClass('pointer');
          return false;
        });
        $('#showtimes').click(function(event) {
          // Act on the event
          var zipcode = prompt("What is your zip code?");
          $('#theaters_zip').val(zipcode);
          $('.zip_form').submit();
          return false;
        });

        $('#recommendation').click(function(event) {
          // Act on the event
          $('#mobile_info').slideToggle();
          $('#recommendation').toggleClass('pointer');
          return false;
        });

        mobileTitle();
      },
      exit: function() {
          $('#info').unbind("click");
          $('#showtimes').unbind("click");
          $('#recommendation').unbind("click");
      }
  });

  jRes.addFunc({
      breakpoint: 'desktop',
      enter: function() {
        title();

        $(window).resize(function() {
          title();
        });

        $('.arrow').hover(function() {
          status('I don\'t want to see ...');
        }, function() {
          status();
        });

        $('.zip_form').hover(function() {
          status('get showtimes for ...');
          $('.zip_form input').addClass('hover');
        }, function() {
          $('.zip_form input').removeClass('hover');
          status();
        });

        $('.zip_form').click(function(event) {
          $('.zip_form').unbind("hover");
          $('#theaters_zip').attr('placeholder', 'ZIP')
          status('enter your zip code to get showtimes for ...');
        });

        var zip_form = $('input#theaters_zip');
        var zip_starting_val = zip_form.val();

        zip_form.bind('keyup blur change paste', function() {
          if (zip_form.val().length==5 && zip_form.val()!=zip_starting_val) {
            zip_form.attr("readonly","readonly");
            $(this).css('color','#616161');
            $(this).css('outline','none');
            $('.zip_form').submit();
          }
        });

        $('#info').hover(function() {
          status('get more information about ...');
        }, function() {
          status();
        });

        $('#info').click(function(event) {
          // console.log('info time');
          var about_the_movie = $('#about_the_movie');
          var    offset = $(this).offset();

          about_the_movie.css({
             top: offset.top,
            left: offset.left+34
          });

          $('#about_the_movie').toggle();
          // change the x

          // text = $(this).text()

          if ($(this).text()=="x") {
            $(this).html('&nbsp;&nbsp;i&nbsp;&nbsp;');
          } else{
            $(this).text('x')
          };

          return false;
        });

        $('#watch_desktop_trailer a').click(function(event) {
          // Act on the event
          // $('#info').click();
          watch_trailer();
          return false;
        });

        $('#recommendation h1 span').click(function(event) {
          // Act on the event
          // $('#desktop_trailer').toggle();
          watch_trailer();
          $('#recommendation h1 span').unbind();
          // $('#desktop_trailer').fadeIn(function(){
            // fixMargin();
          // });
          return false;
        });

        function watch_trailer () {
          $('#about_the_movie').hide();

          if ($('#info').text()=='x') {
            $('#info').html('&nbsp;&nbsp;i&nbsp;&nbsp;');
          };

          player.playVideo();
          // insure i goes back to an x
          $('#desktop_trailer').toggle();
          fixMargin();
        }

        $('#recommendation h1 span').hover(function() {
          status('watch a trailer for ...');
        }, function() {
          status();
        });

      },
      exit: function() {
        $(window).unbind();
        $('.arrow').unbind();
        $('.zip_form').unbind();
        $('#info').unbind();
        $('#recommendation h1 span').unbind();
        // $('#recommendation h1').unbind("hover");
        $('#recommendation').css('margin-top', 'auto');
        $('#about_the_movie').css('display','none');
        player.stopVideo();
        $('#desktop_trailer').css('display','none');
      }
  });


});


function mobileTitle(){
  var max_width = 310;
  var max_height = 175;
  var title = $('#recommendation h1');

  // set default font size
    var def_font_size = ($(window).height() - $('header').height()) / 6
    title.css('font-size',def_font_size+'px');

  while (title.width() > max_width || title.height() > max_height) {
    var current_size = parseInt(title.css('font-size'));

    $('#recommendation h1').css('font-size',(current_size-1)+'px');
  }

  title.css('visibility','visible');
}

function title(){
  var max_width = $(window).width() * .90;
  var title = $('#recommendation h1');
  // fixMargin();

  // set default font size
  var def_font_size = ($(window).height() - $('header').height()) / 6
  title.css('font-size',def_font_size+'px');
  // $('#recommendation h1').css('font-size',def_font_size+'px');

  while (title.width() > max_width ||
        title.height() > parseInt(title.css('line-height'))*2)
  {
    var current_size = parseInt(title.css('font-size'));
    if (current_size==90) {break;};

    $('#recommendation h1').css('font-size',(current_size-1)+'px');
  }
  fixMargin();
  title.css('visibility','visible');
  // $('#recommendation h1').css('visibility','visible');
}

function fixMargin(){
  // var margin = ($(window).height() - $('header').height() - $('#recommendation').height())/2;
  var margin = ( $(window).height() - $('#recommendation').height() )/2;

  showtime_adjust = 0;
  if ($('#theaters').height()) {
    // showtime_adjust = $('#theaters').height();
    showtime_adjust = 60;
  };

  margin = margin - $('header').height() - showtime_adjust;

  // trailer formatting
  if ($('#desktop_trailer').css('display')!='none') {
    // margin = margin - $('#desktop_trailer').height();

    // resize trailer (this can potentially be replaced with better API calls)
    t_max_width = $(window).width()*.95;

    t_height = $(window).height() * .61;
    t_width = t_height*16/9;

    if (t_width>t_max_width) {
      t_width = t_max_width;
      t_height = t_width * 9/16;
    };

    if ($('#theaters')) {
      t_max_height = $(window).height() - $('header').height() - $('#recommendation h3').height() - $('#recommendation h1').height() - $('#theaters').height() - 50;
      if (t_height>t_max_height) {
        t_height = t_max_height;
        t_width = t_height*16/9;
      };
    };

    $('#desktop_trailer iframe').css({
       width: t_width,
      height: t_height
    })

    margin = ( $(window).height() - $('#desktop_trailer').height() - 50 )/2;
    margin = margin - $('header').height() - $('#recommendation h3').height() - $('#info').height();

    if ($('#theaters')) {
      margin = margin - $('#theaters').height();
    };
  };


  // margin = margin - showtime_adjust;
  // margin = .9*margin
  if (margin < 1) { margin = 20};
  $('#recommendation').css('margin-top', margin+'px');
}

function status(message){
  // default status message
  message = message || 'you should see ...';
  $('#recommendation h3').text(message);
}

