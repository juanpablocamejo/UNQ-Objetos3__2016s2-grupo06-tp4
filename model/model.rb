class Sheet
  attr_accessor :rules

  def initialize
    self.rules = []
  end

  def add_new_rule(a_sel, a_hash)
    self.rules << Rule.new(a_sel, a_hash)
  end

  def add_rule(r)
    self.rules << r
  end

  def to_s
    (self.rules.map { |r| r.to_s }).join("\n")
  end
end

class Rule
  attr_accessor :selector, :properties

  def initialize(a_sel, a_hash)
    self.selector = a_sel.to_s
    self.properties=[]
    add_properties(a_hash)
  end

  def add_properties(props)
    self.properties.concat(props)
  end

  def add_property(a_prop)
    self.properties << a_prop
  end

  def to_s
    self.selector.to_s + " {\n" + (self.properties.map { |p| "  #{p.to_s}" }).join("\n") + "\n" + '}'
  end
end

class Property
  attr_accessor :key, :value

  def initialize(a_key, a_val)
    self.key = a_key
    self.value = a_val
  end

  def to_s
    ("#{camel_to_dash(self.key)}: #{camel_to_dash(self.value)};")
  end

  def camel_to_dash(str)
    if str .to_s.start_with? '#'
      str.to_s
    else
      str.to_s.chars.map {
          |c| (is_uppercase_letter? c)?"-#{c.downcase}" : c
      }.join('')
    end
  end

  def is_uppercase_letter? char
     'QWERTYUIOPASDFGHJKLÑZXCVBNM'.include? char
  end

end

class CssValue
end

class NumericValue < CssValue
  attr_accessor :value, :unit

  def initialize(val, unit='')
    self.value = val
    self.unit = unit
  end

  def to_s
    self.value.to_s + self.unit.to_s
  end
end

class ConstantValue < CssValue
  attr_accessor :value

  def initialize(v)
    self.value = v
  end

  def to_sym
    self.value.to_sym
  end

  def to_s
    self.value.to_s
  end
end

class ColorValue < CssValue
  attr_accessor :r, :g, :b, :name

  def initialize(r=0, g=0, b=0, name=nil)
    self.name = name
    self.r = r
    self.g = g
    self.b = b
  end

  def to_s
    name.nil? ? "##{'%02X' % self.r}#{'%02X' % self.g}#{'%02X' % self.b}".upcase : name
  end


end

class MultipleValues
  attr_accessor :values

  def initialize(values)
    self.values = values
  end

  def to_s
    self.values.map{ |v| v.to_s }.join(' ')
  end
end
