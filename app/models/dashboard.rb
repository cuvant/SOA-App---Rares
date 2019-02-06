class Dashboard < ApplicationRecord

  # Dashboard - Table
  #
  # user_id: int 
  # name: string
  # description: text
  # layout: text ( serialized as Array )
  
  serialize :layout, Array
  
  belongs_to :user
  has_many :widgets, dependent: :destroy
  
  validates :user, :name, :description, presence: true

  # Puts all the dashboard's widgets information
  def get_info
    widgets.find_each do |widget|
      widget.get_info
    end
  end
  
  def widgets_text
    "Widgets (#{widgets.size}): #{widgets.map(&:label_type).join(', ')}"
  end
  
  def online?
    DashboardTracker.sub_count(self.id) > 0
  end
  
  def self.online?(dashboard_id)
    DashboardTracker.sub_count(dashboard_id) > 0
  end

end
