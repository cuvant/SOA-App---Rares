class Bound < ApplicationRecord
  belongs_to :widget
  
  validates :lower_bound, :upper_bound, presence: true
  
  validates_numericality_of :lower_bound, less_than: :upper_bound
  validates_numericality_of :lower_bound, greater_than_or_equal_to: 0
  
  validates_numericality_of :upper_bound, greater_than: :lower_bound
  validates_numericality_of :upper_bound, less_than_or_equal_to: 100, if: :test_suite?
  validates_numericality_of :upper_bound, less_than: 1, if: :ap_dex?

  private
  def test_suite?
    return self.widget.is_a?(Widgets::JenkinsTestSuite)
  end
  
  def ap_dex?
    return self.widget.is_a?(Widgets::NewRelic::ApDex)
  end
end
