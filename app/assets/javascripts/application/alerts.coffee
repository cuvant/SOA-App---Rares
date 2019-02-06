window.dashboards = window.dashboards or {}
((alerts, $) ->
  
  
  alerts.confirm_token = (alert_id, widget_id) ->
    token = $("#confirmation_token_#{alert_id}").val()
    if token.length != 4
      $("#errors_#{alert_id}").html("<p style='color:red; padding-top:7px;'>4 characters required!</p>")
      return

    if $("#text_message_confirmation_#{alert_id}").data("started") != true
      alerts.add_spinner(alert_id)
      $("#text_message_confirmation_#{alert_id}").data('started', true)
      $("#confirmation_token_#{alert_id}").prop('disabled', true)
      
      $.ajax
        type: 'post'
        url: location.protocol + "//" + location.host + "/verifications/" + alert_id
        data: {alert_token: token}
        dataType: 'json'
        
        success: (data, textStatus, jqXHR) ->
          $("#errors_#{alert_id}").html("<p style='color:green; padding-top:7px;'>Successfully confirmed!</p>")
          setTimeout (->
            alerts.successfully_confirmed(alert_id, widget_id)
            return
          ), 1000
        
        error: (jqXHR, textStatus, errorThrown) ->
          $("#errors_#{alert_id}").html("<p style='color:red; padding-top:7px;'>Invalid token!</p>")
          $("#confirmation_token_#{alert_id}").prop('disabled', false)
          $("#confirmation_token_#{alert_id}").css('color', 'red')
          $("#text_message_confirmation_#{alert_id}").data('started', false)
  
  alerts.successfully_confirmed = (alert_id, widget_id) ->
    $("#pending-verification-text_#{alert_id}").remove()
    $("#pending_verification_#{alert_id}").remove()
    $("#alerts_labels_#{widget_id}").html("<div class='alert_info'><div class='has_alert'>On</div></div>")
    
    if $(".pending_verification").length == 0
      $("#active-alerts-settings").click()
      $("#pending-alerts-settings").remove()
  
  alerts.add_spinner = (alert_id) ->
    spinner = document.createElement("I");
    spinner.classList.add("fa", "fa-spinner", "fa-spin");
    $("#errors_#{alert_id}").html(spinner)


  alerts.check_token = (input, alert_id) ->
    $("#errors_#{alert_id}").html("")
    token = String($(input).val())
    
    if(token.match(/^\d{4,4}$/))
      $(input).css('color', 'green')
    else
      $(input).css('color', 'red')
  
  alerts.resend_token = (alert_id, widget_id) ->
    $.ajax
      type: 'get'
      data: {}
      url: location.protocol + "//" + location.host + "/verifications/" + alert_id + "/resend_verification"
      dataType: 'json'
      
      success: (data, textStatus, jqXHR) ->
        $("#errors_#{alert_id}").html("<p style='color:green; padding-top:7px;'>#{data.text}</p>")
      
      error: (jqXHR, textStatus, errorThrown) ->
        $("#errors_#{alert_id}").html("<p style='color:red; padding-top:7px;'>#{jqXHR.responseText}</p>")
  
) window.dashboards.alerts = window.dashboards.alerts or {}, jQuery
