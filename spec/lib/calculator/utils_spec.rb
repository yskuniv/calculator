require 'spec_helper'
require_relative '../../../lib/calculator/utils.rb'


describe CalculatorUtils do

  describe '::reduction' do

    it 'reduce a b properly' do
      expect(CalculatorUtils::reduction(2, 4)).to eq [1, 2]
    end

  end

  describe '::factorization' do

    context 'when a prime number is given' do
      it 'returns proper value' do
        expect(CalculatorUtils::factorization(11)).to eq ({ 11 => 1 })
      end
    end

    context 'when a non-prime number is given' do
      it 'returns proper value' do
        expect(CalculatorUtils::factorization(90)).to eq ({ 2 => 1, 3 => 2, 5 => 1 })
      end
    end

    context 'when 0 is given' do
      it 'returns {}' do
        expect(CalculatorUtils::factorization(0)).to eq ({})
      end
    end

    context 'when 1 is given' do
      it 'returns {}' do
        expect(CalculatorUtils::factorization(1)).to eq ({})
      end
    end

  end

  describe '::prime_numbers' do

    it 'returns the prime number list' do
      expect(CalculatorUtils::prime_numbers.take(10)).to eq [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    end

  end

  describe '::is_prime_number?' do

    context 'when a prime number is given' do
      it 'returns true' do
        expect(CalculatorUtils::is_prime_number?(11)).to be_truthy
      end
    end

    context 'when a non-prime number is given' do
      it 'returns false' do
        expect(CalculatorUtils::is_prime_number?(12)).to be_falsey
      end
    end

  end

end
