// new MBP.hideUrlBar();

$(document).ready(function() {
  // Stuff to do as soon as the DOM is ready;
  $('#info').click(function(event) {
    $('#info_box').slideToggle();
    $('#recommendation').toggleClass('pointer');
    return false;
  });
  $('#showtimes').click(function(event) {
    // Act on the event
    var count = prompt("Enter Your Zips Code");
    return false;
  });

  $('#recommendation').click(function(event) {
    // Act on the event
    $('#info_box').slideToggle();
    $('#recommendation').toggleClass('pointer');
    return false;
  });

  fitTitle();


});


function fitTitle(){
  var max_width = 310;
  var max_height = 175;
  var title = $('#recommendation h1');

  while (title.width() > max_width || title.height() > max_height) {
    var current_size = parseInt(title.css('font-size'));

    $('#recommendation h1').css('font-size',(current_size-1)+'px');
  }

}