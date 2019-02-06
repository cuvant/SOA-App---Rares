module DashboardTracker
  
  def self.add_sub(dashboard_id)
    $redis.watch("dashboard_#{dashboard_id}_online")
    
    $redis.multi do
      $redis.INCR("dashboard_#{dashboard_id}_online")
    end
  end
  
  def self.remove_sub(dashboard_id)
    $redis.watch("dashboard_#{dashboard_id}_online")
    
    val = $redis.multi do
      $redis.DECR("dashboard_#{dashboard_id}_online")
    end
    
    if val[0] <= 0
      $redis.del("dashboard_#{dashboard_id}_online")
    end
  end
  
  def self.sub_count(dashboard_id)
    $redis.get("dashboard_#{dashboard_id}_online").to_i
  end

end
