window.dashboards = window.dashboards or {}
((dashboard_channel, $) ->


  dashboard_channel.create_dashboard_subscription = (dashboard_id) ->
    App["dashboard-#{dashboard_id}"] = App.cable.subscriptions.create { channel: "DashboardChannel", dashboard_id: dashboard_id},
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        $("#widget_#{data.widget_id}_value").html(data.value)
        $("#widget_#{data.widget_id}_time").html("Last updated at #{data.recorded_at}")
        
        unless data.in_bounds
          $("#widget_#{data.widget_id}").css('background-color', 'red')
          $("#sound-play").get(0).play()
        else
          $("#widget_#{data.widget_id}").css('background-color', '#47bbb3')


) window.dashboards.dashboard_channel = window.dashboards.dashboard_channel or {}, jQuery
  
