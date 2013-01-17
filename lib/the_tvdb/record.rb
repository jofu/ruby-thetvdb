module TheTVDB
  class Record
    
    class << self
      def client
        @client
      end
      
      def client= (client)
        @client = client
      end
    end
    
    def to_hash
      hash = {}
      instance_variables.each {|var|
        next if var.to_s.delete("@") == 'parent'
        if instance_variable_get(var).is_a? Enumerable
          hash[var.to_s.delete("@")] = []
          instance_variable_get(var).each do |item|
            if item.is_a? TheTVDB::Record
              hash[var.to_s.delete("@")] << item.to_hash
            else
              hash[var.to_s.delete("@")] << item
            end
          end
        else
          if instance_variable_get(var).is_a? TheTVDB::Record
            hash[var.to_s.delete("@")] = instance_variable_get(var).to_hash
          else
            hash[var.to_s.delete("@")] = instance_variable_get(var)
          end
        end
      }
      hash
    end
    
    def parent
      return @parent if @parent
      nil
    end
    
    def parent= (object)
      @parent = object
    end
    
    protected
    
    def string_to_array (string)
      string.sub(/^\|/,'').sub(/\|$/,'').split('|')
    end
    
    def string_to_date (string)
      begin
        return Time.at(Float(string)).gmtime if string.is_number
        return Time.parse(string).gmtime
      rescue
        raise "String '#{string}' is not something that can be turned into a date"
      end
    end
    
  end
end