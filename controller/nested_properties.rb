module NestedProperties
  def nested_properties
    {
        'background' => [
            {'background-size' => ['width', 'height']},
            {'background-color' => ['color']}
        ]
    }
  end

  def nested_property? sym
    nested_properties.keys.include? sym.to_s
  end


end