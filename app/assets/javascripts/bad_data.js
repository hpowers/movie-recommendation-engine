$(document).ready(function() {
  // Stuff to do as soon as the DOM is ready;




  $('#update_score').click(function(event) {

  $.ajax('/movies/1',{
    data: {
      update: {score_adjustment: '25'}
    },
    type: 'put'
  });
  return false;

  });

});
