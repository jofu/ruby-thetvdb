module TheTVDB
  
  VERSION = '0.0.1'
  
  # A couple of additions to the String class
  class String
    def underscore
      self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end
    def is_number?
      true if Float(self) rescue false
    end
  end
  
end