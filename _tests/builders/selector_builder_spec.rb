require_relative '../../controller/builders'
require 'rspec'

describe 'SelectorBuilder' do

  it 'should build a valid selector string with tagname' do
    #arrange
    builder = SelectorBuilder.new
    #act
    builder.instance_eval {
      div
    }
    res = builder.build
    #assert
      expect(res).to eq('div')
  end
  it 'should build a valid selector string with tagname and class' do
    #arrange
    builder = SelectorBuilder.new
    #act
    builder.instance_eval {
      div
      clase
    }
    res = builder.build
    #assert
    expect(res).to eq('div.clase')
  end
  it 'should build a valid selector string with tagname,class and pseudoclass' do
    #arrange
    builder = SelectorBuilder.new
    #act
    builder.instance_eval {
      div
      clase :hover
    }
    res = builder.build
    #assert
    expect(res).to eq('div.clase :hover')
  end
end