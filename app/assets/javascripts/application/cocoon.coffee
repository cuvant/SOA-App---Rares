window.dashboards = window.dashboards or {}
((cocoon, $) ->

  cocoon.init_callback = ->
    $('.alerts').on 'cocoon:after-insert', ->
      $("#widget_form").enableClientSideValidations();
      return
    
) window.dashboards.cocoon = window.dashboards.cocoon or {}, jQuery
