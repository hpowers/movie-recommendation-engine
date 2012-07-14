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
        success: (result) =>
          oTable.fnUpdate(result,$(this).parent()[0],2)
          oTable.fnUpdate(score_adjustment,$(this).parent()[0],3)

        error: ->
          alert('error submitting')
