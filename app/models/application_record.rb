# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true
  
  protected
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
end
