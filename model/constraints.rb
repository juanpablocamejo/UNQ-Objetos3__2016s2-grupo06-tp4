module HTML
  def self.tags
    [:body, :div, :span,
     :form, :input, :select,
     :textarea, :button, :label,
     :img, :a, :table, :th,
     :tr, :td, :p, :ol, :ul,
     :li]
  end

  def self.tag? sym
    self.tags.include? sym
  end
end

module CSS
  def self.constants
    {
        :color => [:blue, :red, :yellow, :white, :black, :green],
        :position => [:absolute, :relative, :static, :fixed],
        :display => [:block, :none, :inline, :inlineBlock],
        :textDecoration => [:none,:underline,:overline,:lineThrough,:initial,:inherit],
        :textAlign => [:left, :right, :center]
    }
  end

  def self.properties
    {
        :color => [ColorValue, ConstantValue],
        :width => [NumericValue],
        :height => [NumericValue],
        :display => [ConstantValue],
        :textDecoration => [ConstantValue],
        :backgroundSize => [MultipleValues],
        :position => [ConstantValue],
        :textAlign => [ConstantValue]
    }
  end

  def self.property? sym
    properties.include? sym
  end

  def self.numeric_units
    {
        px: 'px',
        pt: 'pt',
        pc: '%',
        em: 'em'
    }
  end
end