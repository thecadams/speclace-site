require 'spec_helper'

describe PriceFilter do
  describe '#to_s' do
    it 'supports empty lower' do
      expect(PriceFilter.new(nil,30,'test').to_s).to eq '_to_30'
    end

    it 'supports empty upper' do
      expect(PriceFilter.new(50,nil,'test').to_s).to eq '50_to_'
    end

    it 'supports no bounds' do
      expect(PriceFilter.new(nil,nil,'test').to_s).to eq '_to_'
    end

    it 'supports both bounds' do
      expect(PriceFilter.new(30,50,'test').to_s).to eq '30_to_50'
    end
  end
end