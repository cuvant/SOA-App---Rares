module AlertsHelper
  
  def alert_info(has_alerts)
    if has_alerts
      content_tag(:div, content_tag(:div, "On", class: "has_alert"), class: "alert_info")
    else
      content_tag(:div, content_tag(:div, "Off", class: "no_alert"), class: "alert_info")
    end
  end
end
