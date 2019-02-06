class PopulateBounds < ActiveRecord::Migration[5.1]
  def change
    bound_values = {
      "Widgets::GitHub::Issue" => {lower_bound: "0", upper_bound: "100"},
      "Widgets::GitHub::PullRequest" => {lower_bound: "0", upper_bound: "100"},
      "Widgets::NewRelic::ApDex" => {lower_bound: "0.5", upper_bound: "1"},
      "Widgets::NewRelic::ResponseTime" => {lower_bound: "1", upper_bound: "800"}
    }
    
    Widget.where(type: Widget::REFRESH_TYPES).each do |widget|
      widget.create_bound!(bound_values[widget.type])
    end
    
  end
end
