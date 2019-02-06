class SlackHelpWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(params)
    response_receiver = params["text"].split(' ').include?('only-me') ? 'ephemeral' : 'in_channel'

    message = {
        "response_type": response_receiver,
        "text": "*Golf Genius* Status APP *FAQ*",
        "attachments": [
            {
                "title": "Bugs Command :c-bug:",
    			"text": "`/bugs` By default the command is displaying *unassigned* GitHub issues with label *bugs*, and without *needs review* label. There are the following flags available:",
    			"fields": [
    				{
    					"title": "1. All",
    					"value": "`/bugs all` Displaying all *unasigned* bugs. (Dosen't take into account *needs review* label)"
    				},
    				
    				{
    					"title": "2. User - Displays only the issues assigned to the desired user",
    					"value": "`/bugs user-GitHubUserName`, e.g., `/bugs user-JonDoe`"
    				},
    				
    				{
    					"title": "3. Today - Filters the issues, and displays only the ones open previous day. *Note*: For monday we display issues for the past 3 days.",
    					"value": "`/bugs today`"
    				},
            {
              "title": "4. Only Me - The GG Status APP response will only be sent to you, meaning only you will be able to view it.",
              "value": "`/bugs only-me`"
            },
    				{
    					"title": "Flags can be combined! In any order...awesome, right!? :sunglasses:",
    					"value": "`/bugs today`, `/bugs user-JonDoe today`, `/bugs user-JonDoe`, `/bugs user-JonDoe all`, `/bugs today only-me`"
    				}
    			]
        },
        
        {
            "title": "Honey Badger Command :honeybedger:",
      "text": "`/hb` By default the command is displaying *unassigned* GitHub issues with label *exception*, and without *needs review* label. There are the following flags available:",
      "fields": [
        {
          "title": "1. All",
          "value": "`/hb all` Displaying all *unasigned* exceptions. (Dosen't take into account *needs review* label)"
        },
        
        {
          "title": "2. User - Displays only the issues assigned to the desired user",
          "value": "`/hb user-GitHubUserName`, e.g., `/hb user-JonDoe`"
        },
        
        {
          "title": "3. Today - Filters the issues, and displays only the ones open previous day. *Note*: For monday we display issues for the past 3 days.",
          "value": "`/hb today`"
        },
        {
          "title": "4. Only Me - The GG Status APP response will only be sent to you, meaning only you will be able to view it.",
          "value": "`/hb only-me`"
        },
        {
          "title": "Flags can be combined! In any order...awesome, right!? :sunglasses:",
          "value": "`/hb today`, `/hb user-JonDoe today`, `/hb user-JonDoe`, `/hb user-JonDoe all`, `/hb today only-me`"
        }
      ]
        },


        {
            "title": "Stats Command :wrench:",
      "text": "`/stats` `/stats only-me` Displays in real time Multiple Data Points for Golf Genius",
      # "fields": [
      #   {
      #     "title": "Response Time in MS",
      #   },
      # 
      #   {
      #     "title": "ApDex",
      #   },
      # 
      #   {
      #     "title": "Open Pull Requests",
      #   },
      #   {
      #     "title": "Issues with the following labels *bugs-dev-internal* / *urgent*, *bugs-dev-internal* / *needs review* / *bugs*, *needs review*",
      #   },
      # 
      #   {
      #     "title": "Jenkins Test Suite for Master and Develop branch.",
      #     "value": "*GLG-Develop* - Development Branch | *GolfLeagueGenius* - Master Branch"
      #   },
      # ]
      },
      {
        "title": "Ping Command :table_tennis_paddle_and_ball:",
        "text": "`/ping` `/ping only-me` Sends a ping request to *Dashboards*, and expects a Pong response. Best use case is to wake up the dyno."
      }
  
        ]
    }

    HTTParty.post(params["response_url"], { body: message.to_json, headers: {
        "Content-Type" => "application/json"
      }
    })
  end
end
