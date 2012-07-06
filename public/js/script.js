new MBP.hideUrlBar();

$(document).ready(function() {
  // Stuff to do as soon as the DOM is ready;
  $('#info').click(function(event) {
    $('#info_box').slideToggle();
    return false;
  });
  $('#showtimes').click(function(event) {
    // Act on the event
    var count = prompt("Enter Your Zip Code");
  });
});
