require 'spec_helper'
require_relative '../calculator.rb'


describe Calculator::CFactor do
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

  describe '#simplify' do

    context 'when 1 is given as a base' do
      it 'returns the identity of Rational' do
        expect(Calculator::Exponential[1, Calculator::Rat[2, 3]].simplify).
          to eq Calculator::Rat[1, 1]
      end
    end

    context 'when an integer exponent is given' do
      it 'returns a simple Rational' do
        expect(Calculator::Exponential[2, Calculator::Rat[3, 1]].simplify).
          to eq Calculator::Rat[8, 1]
      end
    end

    context 'when a simple rational exponent is given' do

      context 'in case that only a Exponential is expected to return' do
        it 'returns a proper Exponential' do
          expect(Calculator::Exponential[2, Calculator::Rat[2, 3]].simplify).
            to eq Calculator::Exponential[4, Calculator::Rat[1, 3]]
        end
      end

      context 'in case that a CFactor is expected to return' do
        it 'returns a proper CFactor' do
          expect(Calculator::Exponential[24, Calculator::Rat[1, 2]].simplify).
            to eq Calculator::CFactor[Calculator::Rat[2, 1], Calculator::Exponential[6, Calculator::Rat[1, 2]]]
        end
      end

    end

    context 'when a complicated exponent is given' do

      context 'when e.n < e.d' do
        it 'returns a proper CFactor' do
          expect(Calculator::Exponential[144, Calculator::Rat[2, 3]].simplify).
            to eq Calculator::CFactor[Calculator::Rat[12, 1], Calculator::Exponential[12, Calculator::Rat[1, 3]]]
        end
      end

      context 'when e.n > e.d' do
        it 'returns a proper CFactor' do
          expect(Calculator::Exponential[144, Calculator::Rat[8, 3]].simplify).
            to eq Calculator::CFactor[Calculator::Rat[248832, 1], Calculator::Exponential[12, Calculator::Rat[1, 3]]]
        end
      end

    end

  end

  describe '#multiply' do

    context 'in ordinary case' do
      it 'returns a correct value' do
        expect(Calculator::Exponential[2, Calculator::Rat[1, 3]].multiply(Calculator::Exponential[2, Calculator::Rat[1, 3]])).
          to eq Calculator::Exponential[4, Calculator::Rat[1, 3]]
      end
    end

    context 'when an incompatible one is given' do
      it 'raises an Error' do
        expect { Calculator::Exponential[2, Calculator::Rat[1, 3]].multiply(Calculator::Exponential[3, Calculator::Rat[1, 3]]) }.
          to raise_error(Calculator::Exponential::ExponentialMultiplicationError)
      end
    end

  end

end

describe Calculator::Logarithm do
  pending
end


describe Calculator::Term do

  describe '#simplify' do

    context 'when the term consists of Rationals' do
      it 'simplifies properly (This is not a simple unit test)' do
        expect(Calculator::Term[Calculator::Rat[2, 3], Calculator::Rat[3, 4]].simplify).
          to eq Calculator::Term[Calculator::Rat[1, 2]]
      end
    end

    context 'when the term consists of Exponentials' do
      it 'simplifies properly (This is not a simple unit test)' do
        expect(Calculator::Term[Calculator::Exp[2, Calculator::Rat[1, 3]], Calculator::Exp[2, Calculator::Rat[1, 3]]].simplify).
          to eq Calculator::Term[Calculator::Exp[4, Calculator::Rat[1, 3]]]
      end
    end

  end

  describe '#add' do

    context 'when the term consists of Rationals' do
      it 'adds given properly (This is not a simple unit test)' do
        expect(Calculator::Term[Calculator::Rat[2, 3], Calculator::Rat[3, 4]].add(Calculator::Term[Calculator::Rat[1, 3]])).
          to eq Calculator::Term[Calculator::Rat[5, 6]]
      end
    end

  end

end

describe Calculator::Expression do

  describe '#simplify' do

    context 'when the term consists of Rationals' do
      it 'simplifies properly (This is not a simple unit test)' do
        expect(Calculator::Expression[Calculator::Term[Calculator::Rat[2, 3], Calculator::Rat[3, 4]],
                                      Calculator::Term[Calculator::Rat[1, 3]]].simplify).
          to eq Calculator::Expression[Calculator::Term[Calculator::Rat[5, 6]]]
      end
    end

  end

end
