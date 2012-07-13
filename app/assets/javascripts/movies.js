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
      },
      exit: function() {
        $(window).unbind("resize");
        $('#recommendation').css('margin-top', 'auto');
      }
  });


});


function mobileTitle(){
  var max_width = 310;
  var max_height = 175;
  var title = $('#recommendation h1');

  while (title.width() > max_width || title.height() > max_height) {
    var current_size = parseInt(title.css('font-size'));

    $('#recommendation h1').css('font-size',(current_size-1)+'px');
  }
}

function title(){
  var max_width = $(window).width() * .90;
  var title = $('#recommendation h1');
  fixMargin();

  while (title.width() > max_width ||
        title.height() > parseInt(title.css('line-height'))*2)
  {
    var current_size = parseInt(title.css('font-size'));
    if (current_size==90) {break;};

    $('#recommendation h1').css('font-size',(current_size-1)+'px');
    // $('#recommendation h1').css('margin-left',(current_size-1)+'px');
    fixMargin();
  }
}

function fixMargin(){
  var margin = ($(window).height() - $('header').height() - $('#recommendation').height())/2;
  margin = .9*margin
  if (margin < 1) { margin = 0};
  $('#recommendation').css('margin-top', margin+'px');
}

