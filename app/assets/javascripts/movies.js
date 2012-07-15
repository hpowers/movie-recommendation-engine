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
          $('#info_box').slideToggle();
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
          $('#info_box').slideToggle();
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
          $('#full_info').slideToggle();
          return false;
        });

        $('a.watch_trailer').click(function(event) {
          // Act on the event
          return false;
        });

        // $('#recommendation h1').hover(function() {
        //   status('watch a trailer for ...');
        // }, function() {
        //   status();
        // });

      },
      exit: function() {
        $(window).unbind();
        $('.arrow').unbind();
        $('.zip_form').unbind();
        $('#info').unbind();
        // $('#recommendation h1').unbind("hover");
        $('#recommendation').css('margin-top', 'auto');
        $('#full_info').css('display','none')
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

  while (title.width() > max_width ||
        title.height() > parseInt(title.css('line-height'))*2)
  {
    var current_size = parseInt(title.css('font-size'));
    if (current_size==90) {break;};

    $('#recommendation h1').css('font-size',(current_size-1)+'px');
  }
  fixMargin();
  title.css('visibility','visible');
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
  // if ($('#yt_trailer').height()) {
  //   // margin = margin - $('#yt_trailer').height();
  //   margin = ( $(window).height() - $('#yt_trailer').height() )/2;
  //   margin = margin - $('header').height() - $('#recommendation h3').height();
  // };


  // margin = margin - showtime_adjust;
  // margin = .9*margin
  if (margin < 1) { margin = 0};
  $('#recommendation').css('margin-top', margin+'px');
}

function status(message){
  // default status message
  message = message || 'you should see ...';
  $('#recommendation h3').text(message);
}

