class SlackPingWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(params)
    response_receiver = params["text"].split(' ').include?('only-me') ? 'ephemeral' : 'in_channel'
    
    message = {
      response_type: response_receiver,
      text: "Dashboards says *PONG*! :table_tennis_paddle_and_ball:",
    }

    HTTParty.post(params["response_url"], { body: message.to_json, headers: {
        "Content-Type" => "application/json"
      }
    })
  end
end
