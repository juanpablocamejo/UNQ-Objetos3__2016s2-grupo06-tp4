require 'rspec'
require_relative '../../controller/builders'

describe 'ColorValue' do

  it 'should be #000000 on new(0,0,0)' do
    c=ColorValue.new(0,0,0)
    expect(c.to_s).to eq('#000000')
  end

  it 'should be #FFFFFF on new(255,255,255)' do
    c=ColorValue.new(255,255,255)
    expect(c.to_s).to eq('#FFFFFF')
  end

  it 'should be blue on new(0,0,0,"blue")' do
    c=ColorValue.new(nil,nil,nil,'blue')
    expect(c.to_s).to eq('blue')
  end
end