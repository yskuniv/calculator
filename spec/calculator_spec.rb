require 'spec_helper'
require_relative '../calculator.rb'


describe Calculator::Factor do
  pending
end

describe Calculator::Rational do

  describe '#simplify' do

    it 'returns self' do
      r = Calculator::Rational[1, 1]

      ret = r.simplify

      expect(ret.object_id).to eq r.object_id
    end

    it 'simplifies self properly' do
      r = Calculator::Rational[2, 4]

      r.simplify

      expect([r.numerator, r.denominator]).to eq [1, 2]
    end

  end

  describe '#<<' do

    it 'returns self' do
      ra = Calculator::Rational[1, 1]
      rb = Calculator::Rational[1, 1]

      ret = ra << rb

      expect(ret.object_id).to eq ra.object_id
    end

    it 'multiplies self properly with given' do
      ra = Calculator::Rational[2, 3]
      rb = Calculator::Rational[3, 4]

      ret = ra << rb

      expect([ret.numerator, ret.denominator]).to eq [1, 2]
    end

  end

  describe '#==' do

    before do
      @ra = Calculator::Rational[1, 2]
      @rb = Calculator::Rational[1, 2]
      @rc = Calculator::Rational[2, 3]
    end

    context 'when an equal object is given' do
      it 'returns true' do
        expect(@ra == @rb).to be_truthy
      end
    end

    context 'when a non-equal object is given' do
      it 'returns false' do
        expect(@ra == @rc).to be_falsey
      end
    end

  end

end

describe Calculator::Radical do
  pending
end

describe Calculator::Exponential do
  pending
end

describe Calculator::Logarithm do
  pending
end


describe Calculator::Term do
end

describe Calculator::Expression do
end
