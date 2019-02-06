class Widgets::GitHub::Issue < Widgets::GitHub

  # Validates the presence of custom attributes required for GitHub Issue widget
  validates :filter, presence: true

  def get_info
    begin
      return get_issues_count
    rescue Octokit::Unauthorized, Octokit::InvalidRepository, Octokit::NotFound => e
      raise Widgets::Errors::CredentialsError.new(handle_exception(e))
    end
  end
  
  def alert_text
    text = "#{self.repository} #{self.label_type} widget with the following settings. "
    text << "Labels: #{self.labels}. " if self.labels.present?
    text << "Filter: #{self.filter}. " if self.filter.present?
    text << "State: #{self.state}. " if self.state.present?
    
    return text
  end

  def self.golf_genius(assignee = nil, all = false, page = nil, since = nil, only_sender = false, action)
    label = (action == 'bugs' ? 'bugs' : 'exception')
    gg_widget = self.new(
      oauth_token: '3e07368ea9e7859d652f56e39ec9b736fac8542b',
      user: 'golfgenius',
      repository: 'golfgenius',
      labels: label,
      state: 'open',
      filter: 'all',
      assignee: assignee || 'none',
      slack_command: 'true',
      slack_user: assignee,
      slack_all_issues: all,
      page: page,
      since: since,
      only_sender: only_sender
    )

    gg_widget.get_info
  end

  private
  
  # Returns number of issues
  def get_issues_count
    issues_count
  end
  
  # Inits GitHub connection
  def issues_count
    init_github
    find_issues
  end
  
  # Note: In the past, pull requests and issues were more closely aligned than they are now. 
  # As far as the API is concerned, every pull request is an issue, but not every issue is a pull request.
  # 
  # This endpoint may also return pull requests in the response. 
  # If an issue is a pull request, the object will include a 'pull_request' key.
  
  # Send the request to GitHub Issues API's
  def find_issues
    # count = 0
    # issues = github.list_issues("#{options[:user]}/#{options[:repository]}", request_params)
    # issues.each{ |issue| count+= 1 if !issue.key?(:pull_request) }

    begin
      initial_issues = self.github_client.list_issues("#{user}/#{repository}", request_params)
    rescue StandardError => e
      initial_issues = []

      if self.slack_command?
        return slack_format(true, nil, slack_user, slack_all_issues, nil, only_sender)
      end
    end

    last_page = find_last_page(initial_issues.size)
    return last_page unless self.slack_command?

    return slack_format(false, initial_issues, slack_user, slack_all_issues, last_page, only_sender)
  end
  
  # Builds data that is sent to the API
  def request_params
    data = { }
    
    # labels example: "bug,invalid,question"
    data["labels"] = labels.present? ? labels : ""
    
    # filter example: "assigned" "created" "mentioned" "subscribed" "all"
    data["filter"] = filter
    
    # state example: "open" "closed" "all"
    data["state"] = state

    # used for slack command
    # assignee set to 'non', means we get issues that are not assigned
    data["assignee"] = assignee if assignee.present?

    # used for slack command
    # display issues paginated
    data["page"] = page if page.to_i != 0

    # used for slack command
    # If since parameter represents 'today' flag
    # If its present we will only get issues for the day
    # Now if its Saturday, Sunday or Monday we get issues for last 3 days
    if since.present?
      date = Time.zone.now
      if [6, 0, 1].include?(Time.zone.now.wday)
        days_ago = 3
      else
        days_ago = 1
      end

      data["since"] = (Time.zone.now - days_ago.days).iso8601
    end

    return data
  end

end
