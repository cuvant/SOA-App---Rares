class BugsCommandWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(params, page = nil)
    # message = {
    #   response_type: "in_channel",
    #   text: "This command will display unassigned bugs for the day.",
    #   attachments: [
    #     {
    #       text: "No more copy & paste from GitHub... automatization"
    #     }
    #   ]
    # }

    page = nil
    assignee = nil
    all = false
    since = nil
    only_sender = false

    params["text"].split(' ').each do |flag|

      if flag.include?('page-')
        page = flag.sub('page-', '').to_i
      elsif flag.include?('user-')
        assignee = flag.sub('user-', '')
      elsif flag.include?('all')
        all = true
      elsif flag.include?('today')
        since = true
      elsif flag.include?('only-me')
        only_sender = true
      end

    end

    HTTParty.post(params["response_url"], { body: Widgets::GitHub::Issue.golf_genius(assignee, all, page, since, only_sender, params["action"]).to_json, headers: {
        "Content-Type" => "application/json"
      }
    })

  end
end
