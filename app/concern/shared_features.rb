module SharedFeatures
  extend ActiveSupport::Concern
  
  # Returns the widget view type, for example: "Number, Iframe, Chart, etc.."
  def view_type
  end
  
  # Returns the widgets type, underscored
  # For example: Widgets::NewRelic::ApDex returns ap_dex
  # Used in rendering specific partials for the widget
  # Example: render "widgets/forms/widget.partial_name" and we have the _ap_dex.html.haml partial
  def partial_name
    return self.type.split("::")[-1].underscore
  end
  
  # Returns the label type of a widget
  # For example a widget of type GitHub::Issues 
  # Will return Issues
  def label_type
    self.type.split("::").last.gsub(/(?<=[a-z])(?=[A-Z])/, ' ')
  end
  
  # Method that creates getters and setters for each OPTIONS key/value
  # For example we can then have widget.repository, this refers to widget.options[:repository]
  # Or do mass asigments like Widget.new(type: "Widgets::GitHub::PullRequest", repository: "Dashboards-Orc", user: "Jon Doe")
  def self.serialized_options_attr_accessor(*args)
    args.each do |method_name|
      define_method(method_name) do
        (self.options || {})[method_name.to_sym]
      end
      
      define_method("#{method_name}=") do |value|
        self.options ||= {}
        self.options[method_name.to_sym] = value
      end
    end
  end

  # Formats the response Hash sent to Slack
  # This hash will be displayed in nice looking text in the slack channel
  def slack_format(error = false, issues = nil, user = nil, all = false, last_page = nil, only_sender = false)
    response = { response_type: "#{only_sender ? 'ephemeral' : 'in_channel'}" }
    issue_type = self.labels == 'bugs' ? 'Bugs' : 'Honey Badgers'

    if error
      response[:text] = "User *#{user}* not found in *GitHub*... Did you misspell it?"
      return response
    end

    if issues.blank?
      response[:text] = "*0* - Unassigned Bugs,#{ Date.today.strftime("%e %B")}"
      return response
    end

    unless all
      new_issues = []

      issues.each do |issue|
        needs_review = false

        if issue[:labels].present?
          issue[:labels].each do |label|
            needs_review = true if label[:name] == "needs review"
          end
        end

        if needs_review == false
          new_issues << issue
        end
      end

      issues = new_issues
    end

    issues_size = issues.size

    pagination_text = ''
    if (last_page.present? && last_page.to_i != 1) || (self.page.present?)
      issues_size = "More than #{25 * (last_page.to_i > 1 ? (last_page.to_i - 1) : 1)} (displaying #{issues_size} - page #{self.page || 1})"
      command = self.labels == 'bugs' ? '/bugs' : '/hb'
      pagination_text = "To view the rest of *#{issue_type}* use `page-X` flag, available pages `1..#{last_page}`. E.g., `#{command} page-2`"
    end

    if user.present?
      if all
        response[:text] = "There are in total *#{issues_size}* assigned *#{issue_type}* to *#{user}*, #{Date.today.strftime("%e %B")}"
      else
        response[:text] = "*#{issues_size}* - Assigned *#{issue_type}* to *#{user}*, #{Date.today.strftime("%e %B")}"
      end
    else
      response[:text] = "*#{issues_size}* - Unassigned *#{issue_type}*, #{ Date.today.strftime("%e %B")}"
    end

    response[:attachments] = []

    issues.each_with_index do |issue, index|
      attachement = {}

      attachement[:text] = "#{index + 1}. "

      attachement[:text] << (issue[:title].truncate(200) rescue '')
      attachement[:text] << " "
      attachement[:text] << issue[:url].sub('https://api.github.com/repos', 'https://github.com')
      
      response[:attachments] << attachement
    end

    if pagination_text.present?
      response[:attachments].unshift({text: pagination_text})
    end

    return response
  end
end
