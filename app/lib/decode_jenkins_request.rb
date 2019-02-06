module DecodeJenkinsRequest
  
  
  # Decodes a string
  # value = "Coverage report generated for RSpec to /mnt/jenkins_home/workspace/GLG-Develop/coverage. 60124 / 82615 LOC (72.78%) covered."

  # Returns a hash
  # { lines_covered: 60124, total_lines: 82615, coverage: 72.78 }
  
  def self.decode(value)
    val = value.split("coverage.")
    # val = ["Coverage report generated for RSpec to /mnt/jenkins_home/workspace/GLG-Develop/", " 60124 / 82615 LOC (72.78%) covered."] 
    
    val = val[1].split("covered.")
    # val = [" 60124 / 82615 LOC (72.78%) "] 
    
    val = val[0].split("LOC")
    # val = [" 60124 / 82615 ", " (72.78%) "] 
    
    val[0] = val[0].gsub(/\s+/, "").split("/")
    val[1] = val[1].gsub(/[()%]/, '(' => '', ')' => '', '%' => '').to_f
    # val = [["60124", "82615"], 72.78]

    return { lines_covered: val[0][0].to_i, total_lines: val[0][1].to_i, coverage: val[1] }
  end
  
end
