class Widgets::GitHub::PullRequest < Widgets::GitHub

  def get_info
    begin
      return get_pulls_count
    rescue Octokit::Unauthorized, Octokit::InvalidRepository, Octokit::NotFound => e
      raise Widgets::Errors::CredentialsError.new(handle_exception(e))
    end
  end
  
  def alert_text
    return "#{self.repository} #{self.label_type} widget with state #{self.state}. "
  end
  
  private
  
  # Returns the number of pull requests
  def get_pulls_count
    pulls_count
  end
  
  # Inits GitHub connection
  def pulls_count
    init_github
    find_pulls
  end
  
  # Send the request to GitHub Issues API's
  def find_pulls
    # return self.github_client.pull_requests("#{user}/#{repository}", request_params).count
    initial_pulls = self.github_client.pull_requests("#{user}/#{repository}", request_params).count
    return find_last_page(initial_pulls)
  end
  
  # Builds data that is sent to the API
  def request_params
    # state example: "open" "closed" "all"
    return { "state": state }
  end

end
