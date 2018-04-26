require 'spec_helper'
require_relative '../calculator.rb'


describe Calculator::Factor do
  pending
end

describe Calculator::Rational do

  describe '#simplify' do

    it 'simplifies properly' do
      expect(Calculator::Rational[2, 4].simplify).to eq Calculator::Rational[1, 2]
    end

  end

  describe '#multiply' do

    it 'multiplies with given properly' do
      expect(Calculator::Rational[2, 3].multiply(Calculator::Rational[3, 4])).to eq Calculator::Rational[1, 2]
    end

  end

  describe '#add' do

    it 'adds given properly' do
      expect(Calculator::Rational[2, 3].add(Calculator::Rational[5, 6])).to eq Calculator::Rational[3, 2]
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

    it 'simplifies properly (This is not a simple unit test)' do
      expect(Calculator::Term[Calculator::Rat[2, 3], Calculator::Rat[3, 4]].simplify).
        to eq Calculator::Term[Calculator::Rat[1, 2]]
    end

  end

  describe '#add' do

    it 'adds given properly (This is not a simple unit test)' do
      expect(Calculator::Term[Calculator::Rat[2, 3], Calculator::Rat[3, 4]].add(Calculator::Term[Calculator::Rat[1, 3]])).
        to eq Calculator::Term[Calculator::Rat[5, 6]]
    end

  end

end

describe Calculator::Expression do

  describe '#simplify' do

    it 'simplifies properly (This is not a simple unit test)' do
      expect(Calculator::Expression[Calculator::Term[Calculator::Rat[2, 3], Calculator::Rat[3, 4]],
                                    Calculator::Term[Calculator::Rat[1, 3]]].simplify).
        to eq Calculator::Expression[Calculator::Term[Calculator::Rat[5, 6]]]
    end

  end

end
