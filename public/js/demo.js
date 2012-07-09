$(document).ready(function() {
  // Stuff to do as soon as the DOM is ready;

    $.getJSON('http://movie.dev/movies/1/theaters/94301.json', function(data){
      var source = $("#some-template").html();
      // look at pre-compiling the template
      // http://handlebarsjs.com/precompilation.html
      var template = Handlebars.compile(source);
      $("#content-placeholder").html(template(data));
    });

});
