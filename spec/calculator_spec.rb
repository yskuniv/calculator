require 'spec_helper'
require_relative '../calculator.rb'


describe Calculator::Factor do
  pending
end

describe Calculator::Rational do

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

  describe '#simplify' do

    it 'simplifies self properly' do
      r = Calculator::Rational[2, 4]

      expect(proc {
               res = r.simplify
               [res.numerator, res.denominator]
             }[]).to eq [1, 2]
    end

  end

  describe '#multiply' do

    it 'multiplies self with given properly' do
      ra = Calculator::Rational[2, 3]
      rb = Calculator::Rational[3, 4]

      expect(proc {
               res = ra.multiply(rb)
               [res.numerator, res.denominator]
             }[]).to eq [1, 2]
    end

  end

  describe '#add' do

    it 'adds given to self properly' do
      ra = Calculator::Rational[2, 3]
      rb = Calculator::Rational[5, 6]

      expect(proc {
               res = ra.add(rb)
               [res.numerator, res.denominator]
             }[]).to eq [3, 2]
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

  describe '#simplify' do

    it 'simplifies self properly (This is not a simple unit test)' do
      t = Calculator::Term[Calculator::Rat[2, 3], Calculator::Rat[3, 4]]

      expect(proc {
               res = t.simplify
               res.factors
             }[]).to eq [Calculator::Rat[1, 2]]
    end

  end

  describe '#add' do

    it 'multiplies self with given properly (This is not a simple unit test)' do
      ta = Calculator::Term[Calculator::Rat[2, 3], Calculator::Rat[3, 4]]
      tb = Calculator::Term[Calculator::Rat[1, 3]]

      expect(proc {
               res = ta.add(tb)
               res.factors
             }[]).to eq [Calculator::Rat[5, 6]]
    end

  end

end

describe Calculator::Expression do

  describe '#simplify' do

    it 'works properly (This is not a simple unit test)' do
      e = Calculator::Expression[Calculator::Term[Calculator::Rat[2, 3], Calculator::Rat[3, 4]],
                                 Calculator::Term[Calculator::Rat[1, 3]]]

      expect(proc {
               res = e.simplify
               res.terms
             }[]).to eq [Calculator::Term[Calculator::Rat[5, 6]]]
    end

  end

end
