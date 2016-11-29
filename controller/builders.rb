require_relative '../model/constraints'
require_relative '../model/exceptions'
require_relative 'nested_properties'
require_relative 'values_helpers'


class SheetBuilder
  include ValuesHelpers
  attr_accessor :sheet, :rules_builder, :selector_builder

  def initialize
    self.sheet = Sheet.new
    self.rules_builder = RulesBuilder.new
    self.selector_builder = SelectorBuilder.new
    self.selector_builder.rules_builder = self.rules_builder
  end

  def mixin(name,&bk)
    PropertiesBuilder.add_mixin(name, Proc.new(&bk))
  end

  def method_missing(name, *args, &bk)
    if name.to_s != 'let'
    self.selector_builder.send(name, *args)
    if block_given?
      self.rules_builder.with_rule(self.selector_builder.build, &bk)
      self.rules_builder
    end
    self
    end
  end

  def build
    self.sheet.rules = self.rules_builder.build()
    self.sheet
  end
end

class SelectorBuilder
  attr_accessor :selector, :rules_builder

  def initialize
    self.selector = ''
  end

  def method_missing(name, *args, &bk)
    if HTML.tag? name
      add_tag(name)
    elsif self.is_id? name
      add_id(name)
    else
      add_class(name)
    end
    add_params(args)
  end

  def add_params(args)
    self.selector += args.map {
        |s| (s.is_a? Symbol) ? ' :' + s.to_s : s.to_s
    }.join('')
  end

  def is_id?(name)
    name.to_s[0] == '_'
  end

  def add_id(name)
    self.selector += '#' + name.to_s[1..-1]
  end

  def add_class(name)
    self.selector += '.' + name.to_s
  end

  def add_tag(name)
    self.selector += self.selector.empty? ? name.to_s : ' ' + name.to_s
  end

  def build
    result = self.selector
    self.selector = ''
    result
  end
end

class RulesBuilder
  attr_accessor :rules

  def initialize()
    self.rules = []
  end

  def with_rule(selector, &bk)
    builder = PropertiesBuilder.new
    builder.instance_eval(&bk)
    self.rules << Rule.new(selector, builder.build)
    self
  end

  def build
    rules
  end

end

class PropertiesBuilder
  include NestedProperties, ValuesHelpers
  attr_accessor :properties
  @@mixins = {}

  def self.get_mixin(name)
    @@mixins[name]
  end

  def self.add_mixin(name, proc)
    @@mixins[name] = proc
  end

  def initialize
    self.properties = []
  end

  def method_missing(name, *args, &bk)
    if name == :with
      self.instance_eval('undef :display')
      self.instance_eval(&PropertiesBuilder.get_mixin(args.first))
    elsif block_given?
      resolve_nested_property(name, &bk)
    else
      resolve_single_property(name, args[0])
    end
    self
  end

  def validate_property(key, val)
    raise InvalidPropertyNameException.new unless CSS.property? key
    raise InvalidPropertyValueException.new unless is_valid?(key, val)
  end

  def resolve_single_property(key, val)
    value = to_value(val)
    validate_property(key, value)
    self.properties << Property.new(key, value)
  end

  def resolve_nested_property(name, &bk)
    builder = PropertiesBuilder.new
    source_props = builder.instance_eval(&bk).build
    prop_mappings = nested_properties[name.to_s]
    prop_mappings.each { |prop_map|
      values = extract_nested_values(source_props, prop_map)
      self.properties << Property.new(prop_map.keys[0], MultipleValues.new(values)) unless values.empty?
    }
  end

  def extract_nested_values(source_props, prop_map)
    values = []
    prop_map.values[0].each { |nested_key|
      _has, _val = find_nested_prop(nested_key, source_props)
      values << _val if _has
    }
    values
  end

  def find_nested_prop(sym, prop_arr)
    has_prop, val = false, nil
    prop_arr.each { |p|
      if sym.to_s == p.key.to_s
        has_prop = true
        val = p.value
        break
      end
    }
    return has_prop, val
  end

  def build
    self.properties
  end

end
