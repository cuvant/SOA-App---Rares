window.dashboards = window.dashboards or {}
((widgets, $) ->
  
  widgets.set_form = ->
    $('input[name="widget_type_radio"]').on 'ifChecked', (event) ->
      type = $(event.target).val()
      $.ajax
        type: 'get'
        url: location.protocol + "//" + location.host + "/set_form/" + type
        data: {dashboard_id: window.dashboard_id}
        dataType: 'script'
    
) window.dashboards.widgets = window.dashboards.widgets or {}, jQuery
