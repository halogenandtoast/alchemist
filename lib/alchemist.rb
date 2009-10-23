require 'alchemist/numeric_conversion.rb'

class Numeric
  def from(type)
    NumericConversion.new(self, type)
  end
  
  def to(type)
    from(type)
  end
  
  def method_missing(method,*args, &block)
     dummy, unit = NumericConversion.parse_prefix(method)
     NumericConversion.conversion_table.each do |type, conversions|
       if conversions.keys.include?(unit)
         return self.from(method)
       end
     end
     super
  end
  
end