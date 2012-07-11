$(document).ready(function() {

  if ($('body.theaters-show').length > 0) {

    var id = $('#theaters').data('id');

    $.getJSON(id+'.json', function(data){
      var source = $("#showtimes-template").html();
      // look at pre-compiling the template
      // http://handlebarsjs.com/precompilation.html
      var template = Handlebars.compile(source);
      $("#theaters").html(template(data));
    });

  };

});
