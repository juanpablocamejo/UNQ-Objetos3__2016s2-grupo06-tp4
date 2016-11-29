require_relative '../model/constraints'
require_relative '../model/exceptions'
require_relative '../model/model'

module ValuesHelpers
  def self.included(base)
    self.define_constants(base)
    self.define_numeric_units
  end

  def self.define_numeric_units
    CSS.numeric_units.each {
        |unit, repr| Numeric.send(:define_method,unit){ NumericValue.new(self, repr) }
    }
  end

  def self.define_constants(base)
    # Object.instance_eval('undef :display')
    CSS.constants.values.flatten.each {
        |v| base.send(:define_method,v) {
        ConstantValue.new(v)
      }
    }
  end

  def is_valid?(prop, val)
    is_valid_type = false
    valid_types = CSS.properties[prop]
    valid_types.each { |t|
      if val.is_a? t then
        is_valid_type=true; break;
      end }
    if is_valid_type && val.is_a?(ConstantValue)
      CSS.constants[prop].include? val.to_sym
    end
    is_valid_type
  end


  def rgb(r, g, b)
    ColorValue.new(r, g, b)
  end

  def to_value(v)
    if v.is_a? Numeric
      NumericValue.new(v)
    elsif v.is_a? CssValue
      v
    else
      raise InvalidPropertyValueException
    end
  end
end