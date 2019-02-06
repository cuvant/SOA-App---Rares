window.dashboards = window.dashboards or {}
((widgets, $) ->

  widgets.get_data = (widget_id, url) ->
    $.ajax
      type: 'get'
      url: url
      dataType: 'json'
      success: (data) ->
        $("#widget_#{widget_id}_value").html(data.value)
        $("#widget_#{widget_id}_time").html("Last updated at #{data.time}")

        if data.lines_covered != undefined && data.total_lines != undefined
          $("#change_rate_#{widget_id}").html("#{data.lines_covered} / #{data.total_lines}")
        
        if data.total_used != undefined && data.instance_count != undefined
          $("#total_used_#{widget_id}").html("App Total Usage: #{data.total_used} GB")
          $("#instance_count_#{widget_id}").html("Running Instances: #{data.instance_count}")

        if data.in_bounds
          $("#widget_#{widget_id}").css('background-color', '#47bbb3')
        else
          $("#widget_#{widget_id}").css('background-color', 'red')

  widgets.set_scheduler = (widget_id, url) ->
    widgets.get_data(widget_id, url)

    setInterval (->
      widgets.get_data(widget_id, url)
      return
    ), 30000
    return

) window.dashboards.widgets = window.dashboards.widgets or {}, jQuery
