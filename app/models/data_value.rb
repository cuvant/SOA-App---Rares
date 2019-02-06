class DataValue < ApplicationRecord

  belongs_to :widget

  validates :widget_id, :value, :recorded_at, presence: true
  
  scope :jenkins_current_value, -> { order(recorded_at: :desc).limit(1).pluck(:value, :recorded_at, :in_bounds, :lines_covered, :total_lines).flatten }
  scope :current_value, -> { order(recorded_at: :desc).limit(1).pluck(:value, :recorded_at, :in_bounds).flatten }
  scope :new_relic_current_value, -> { order(recorded_at: :desc).limit(1).pluck(:value, :recorded_at, :in_bounds, :total_used, :instance_count).flatten }
end
