# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
        window.oTable = $('#movie_data').dataTable(
          'iDisplayLength': 100
        )

        $(".score_adjustment").click (event) ->
          id = $(this).data('id')
          score_adjustment = prompt("Score Adjustment for "+id)

          if score_adjustment
            $.ajax "/movies/"+id,
              data:
                update:
                  score_adjustment: score_adjustment
              type: "put"
              success: =>
                console.log(this)
                $(this).text(score_adjustment)
                # $('#score-'+id).parent()[0]
                $('#score-'+id).load('/movies/'+id+'/score')
                # working example
                #oTable.fnUpdate('55',$('table tr:eq(3)')[0],2)
                # oTable.fnUpdate($('#score-'+id).text(),$('#score-'+id).parent()[0],2)
              error: ->
                alert('error submitting')
