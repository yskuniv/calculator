require 'spec_helper'
require_relative '../calculator.rb'


describe Calculator::Factor do
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

end

describe Calculator::Radical do
end

describe Calculator::Exponential do
end

describe Calculator::Logarithm do
end


describe Calculator::Term do
end

describe Calculator::Expression do
end
