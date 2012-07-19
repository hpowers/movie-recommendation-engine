$ ->
  if $("body.theaters-show").length > 0
    id = $("#theaters").data("id")
    $.getJSON id + ".json", (data) ->
      template = Handlebars.templates["showtimes.tmpl"]
      $("#theaters").html template(data)

      # should mobile show all theaters by default?
      # $("#theaters").append "<div id=\"more\"><a href=\"#\">FIND MORE THEATERS</a></div>"
