class Widgets::GitHub < Widget

  attr_accessor :github_client
  serialized_options_attr_accessor :oauth_token, :repository, :user, :labels, :filter, :state, :assignee, :slack_command, :slack_user, :slack_all_issues, :page, :since, :only_sender
  
  # Validates the presence of custom attributes required for GitHub widgets
  validates :user, :oauth_token, :repository, :state, presence: true
  
  
  # Virtual method that is implemented in child classes
  def get_info
  end

  # Returns provider type
  # Used in dashboard edit view
  def provider
    return "Git Hub"
  end
  
  # Sets the model name to Widget
  # So form_for will route to WidgetsController using 'widget' params
  def self.model_name
    Widget.model_name
  end

  protected

  # Returns True if the Widget is used for Slack Command
  # False if Its a normal widget
  def slack_command?
    @isslack_command ||= (self.slack_command == 'true')
  end
  
  # Inits GitHub client instance variable
  # Only one instance / widget
  # We only want the number of Issues / Pull Requests 
  # To do so we use the following method:
  # 1. Send request for 1 Issue / Pull Request
  # 2. Check the response header for the last page link
  # 3. From the link extract the last page number
  # 4. So the number we are looking for is the last page number
  def init_github
    return self.github_client if self.github_client.present?
    per_page = slack_command? ? 25 : 1

    self.github_client = Octokit::Client.new(access_token: oauth_token, per_page: per_page)
  end
  
  
  # Parameters: 'inital_count'
  # Output: number of Issues / Pull Requests
  # 'initial_count' can be 1 or 0, because we limit Issues / Pull Requests to 1 per page
  # After a request, in the response header we can find the next page link ( if there is a next page )
  # In case of next page link existing we parse it and find the last page number
  #    THE LAST PAGE NUMBER IS THE NUMBER OF ISSUES / PULL REQUESTS, BECAUSE WE PAGINATE PER_PAGE = 1
  # If there is not a next page, that means the 'initial_count' is the number of Issues / Pull Requests
  
  # Example of last_page: "<https://api.github.com/repositories/93545190/issues?filter=all&labels=bug%2Cduplicate%2Cquestion&per_page=1&state=open&page=2>; rel=\"next\", <https://api.github.com/repositories/93545190/issues?filter=all&labels=bug%2Cduplicate%2Cquestion&per_page=1&state=open&page=2>; rel=\"last\""
  # From this example we extract the last page number "page=2" => 2
  def find_last_page(inital_count)
    last_page = self.github_client.last_response.headers["link"]
    
    if last_page.present?
      last_page = last_page.split(";")[1].split(",")[1].split("page=").last.gsub(">", "")

      return last_page if last_page.to_i.to_s.size == last_page.size
    end

    return 1 if self.github_client.last_response.headers["link"].blank?

    # For example in case of slack commands we can use `page-X` flag
    # If there are in total 5 pages and we use `page-2` flag
    # The above calculation for last page won't work
    # Thus we need to calculate it using the following code
    if (last_page.to_i.to_s.size != last_page.size) && slack_command?
      array_of_links = self.github_client.last_response.headers["link"].split(';')
      array_of_links.each_with_index do |str, index|
        next if str.exclude?('last')
        last_page = array_of_links[index-1].split('page=')[1].to_i
      end
      
      # In case we do last `page-5` the last page
      # Then again the avobe code won't work
      if last_page.to_i.to_s.size != last_page.size
        last_page = self.github_client.last_response.headers["link"].split(';')[0].split('page=')[1].to_i + 1
      end
      
      return last_page
    else
      return inital_count.to_s
    end
  end
  
  def handle_exception(e)
    case e
    when Octokit::Unauthorized
      return "Unauthorized, invalid 'Access Token'."
    when Octokit::InvalidRepository
      return "Invalid format. Check 'User' or 'Repository'."
    when Octokit::NotFound
      return "'User' or 'Repository' not found."
    end
  end

end
