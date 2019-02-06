class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "dashboard:#{params['dashboard_id']}"
    DashboardTracker.add_sub(params['dashboard_id'])
  end

  def unsubscribed
    DashboardTracker.remove_sub(params['dashboard_id'])
  end
end
