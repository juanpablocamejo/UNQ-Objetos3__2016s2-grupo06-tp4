require_relative '../../model/constraints'
require_relative '../../model/model'
require_relative '../../controller/values_helpers'
require_relative '../../controller/builders'
require 'rspec'

describe 'Property Builder' do
  it 'should build ok single property with numeric value' do
    #arrange
    builder = PropertiesBuilder.new

    #act
    builder.instance_eval {
      width 80.px
    }
    properties = builder.build
    #assert
    expect(properties.empty?).to be(false)
    expect(properties[0].key).to eq(:width)
    expect(properties[0].value.to_s).to eq('80px')
  end

  it 'should build ok single property with color value' do
    #arrange
    builder = PropertiesBuilder.new
    #act
    builder.instance_eval {
      color rgb(0,0,0)
    }
    properties = builder.build
    #assert
    expect(properties.empty?).to be(false)
    expect(properties[0].key).to eq(:color)
    expect(properties[0].value.to_s).to eq('#000000')
  end

  it 'should build ok a valid nested property' do
    #arrange
    builder = PropertiesBuilder.new
    #act
    builder.instance_eval {
      background {
        height 200.px
        width 200.px
        color blue
      }
    }
    properties = builder.build
    #assert
    expect(properties.size).to be(2)
    expect(properties[0].to_s).to eq('background-size: 200px 200px;')
    expect(properties[1].to_s).to eq('background-color: blue;')

  end
  it 'should raise InvalidPropertyValueException on invalid valueType' do
    #arrange
    builder = PropertiesBuilder.new
    #act / assert
    expect {
    builder.instance_eval {
      color 50.px
    } }.to raise_error(InvalidPropertyValueException)
  end
  it 'should raise InvalidPropertyValueException on invalid constant' do
    #arrange
    builder = PropertiesBuilder.new
    #act / assert
    expect {
      builder.instance_eval {
        color blueh
      } }.to raise_error(InvalidPropertyValueException)
  end
  it 'should raise InvalidPropertyNameException on invalid property name' do
    #arrange
    builder = PropertiesBuilder.new
    #act / assert
    expect {
      builder.instance_eval {
        colour blue
      } }.to raise_error(InvalidPropertyNameException)
  end
end