class GolfGeniusStatusWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(params)
    response_receiver = params["text"].split(' ').include?('only-me') ? 'ephemeral' : 'in_channel'
    response = { response_type: response_receiver }
    response[:attachments] = []

    Widget.where(dashboard_id: [1, 8]).each do |widget|
      attachement = {}
      value = widget.value
      status = value[:in_bounds] ? ":white_check_mark:" : ":x:"
      
      if widget.is_a?(Widgets::GitHub)
        value[:value] = value[:value].to_i
      end

      labels = ''
      if widget.is_a?(Widgets::GitHub::Issue)
        results = []
        labels = widget.labels.split(',').each do |label|
          label.prepend('*')
          label << '*'
          results << label
        end

        labels = "- #{results.join(', ')}"
      end
      
      if widget.is_a?(Widgets::JenkinsTestSuite)
        labels = "- *#{widget.branch}*"
      end

      value = value[:value]

      if widget.is_a?(Widgets::NewRelic::ResponseTime)
        value = "#{value} ms"
      end

      attachement[:text] = "#{status} - *#{value}* #{widget.label_type} #{labels}"
      
      response[:attachments] << attachement
    end

    HTTParty.post(params["response_url"], { body: response.to_json, headers: {
        "Content-Type" => "application/json"
      }
    })

  end
end
