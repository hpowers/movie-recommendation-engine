$(document).ready(function() {
  // Stuff to do as soon as the DOM is ready;

  // only execute on showtimes page
  if ($('#showtimes').length > 0) {
    // alert('correct page')

    var id = $('#showtimes').data('id');

    $.getJSON(id+'.json', function(data) {

      list = '';

      $.each(data, function(i,item){

        list += '<li><b>'+item.theater.name+'</b> - '+item.theater.address+'<li>';

      });

      $('#showtimes').toggle();
      $('#showtimes').html('<ul>'+list+'</ul>');
      $('#showtimes').slideToggle();

    });

  }

});
