$(document).ready(function() {

  if ($('body.theaters-show').length > 0) {

    var id = $('#theaters').data('id');

    $.getJSON(id+'.json', function(data){
      var template = Handlebars.templates['showtimes.tmpl']
      $("#theaters").html(template(data));
      $("#theaters").append('<div id="more"><a href="#">FIND MORE THEATERS</a></div>');
    });

  };

});
