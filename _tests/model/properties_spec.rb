require_relative '../../model/model'
require_relative '../../controller/values_helpers'
require 'rspec'

describe 'Property' do
  include ValuesHelpers
  it 'with NumericValue should return "name: value<unit>;" on to_s' do
    #arrange
    _prop = Property.new(:width,NumericValue.new(80,'px'))
    #act
    res = _prop.to_s
    #assert
    expect(res).to eq('width: 80px;')
  end

  it 'with ConstantValue should return "name: constant;" on to_s' do
    #arrange
    _prop = Property.new(:display,ConstantValue.new(:none))
    #act
    res = _prop.to_s
    #assert
    expect(res).to eq('display: none;')
  end

  it 'with ColorValue should return "name: #RRGGBB;" on to_s' do
    #arrange
    _prop = Property.new(:color,rgb(10,0,255))
    #act
    res = _prop.to_s
    #assert
    expect(res).to eq('color: #0A00FF;')
  end

  it 'with MultipleValues should return "name: val1 val2;" on to_s' do
    #arrange
    val1 = NumericValue.new(1000,'px')
    val2 = NumericValue.new(800,'px')
    _prop = Property.new(:backgroundSize,MultipleValues.new([val1,val2]))
    #act
    res = _prop.to_s
    #assert
    expect(res).to eq('background-size: 1000px 800px;')
  end
end