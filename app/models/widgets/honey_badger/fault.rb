class Widgets::HoneyBadger::Fault < Widgets::HoneyBadger
  
  def get_info
    get_faults_count
  end
  
  def alert_text
    "#{self.application_name} #{self.label_type} Widget. "
  end
  
  private
  
  def get_faults_count
    config_honey_badger
    faults_count
  end
  
  def faults_count
    return Honeybadger::Api::Project.find(self.project_id).unresolved_fault_count
  end
  
end
