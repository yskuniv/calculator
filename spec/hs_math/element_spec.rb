include HsMath


RSpec.describe HsMath do
  it "has a version number" do
    expect(HsMath::VERSION).not_to be nil
  end

  describe CFactor do
    pending
  end

  describe Rational do

    describe '#simplify' do

      it 'simplifies properly' do
        expect(Rat[2, 4].simplify).to eq Rat[1, 2]
      end

    end

    describe '#multiply' do

      it 'multiplies with given properly' do
        expect(Rat[2, 3].multiply(Rat[3, 4])).to eq Rat[1, 2]
      end

    end

    describe '#add' do

      it 'adds given properly' do
        expect(Rat[2, 3].add(Rat[5, 6])).to eq Rat[3, 2]
      end

    end

  end

  describe Radical do
    pending
  end

  describe Exponential do

    describe '#simplify' do

      context 'when 1 is given as a base' do
        it 'returns the identity of Rational' do
          expect(Exp[1, Rat[2, 3]].simplify).
            to eq Rat[1, 1]
        end
      end

      context 'when an integer exponent is given' do
        it 'returns a simple Rational' do
          expect(Exp[2, Rat[3, 1]].simplify).
            to eq Rat[8, 1]
        end
      end

      context 'when a simple rational exponent is given' do

        context 'in case that only a Exponential is expected to return' do
          it 'returns a proper Exponential' do
            expect(Exp[2, Rat[2, 3]].simplify).
              to eq Exp[4, Rat[1, 3]]
          end
        end

        context 'in case that a CFactor is expected to return' do
          it 'returns a proper CFactor' do
            expect(Exp[24, Rat[1, 2]].simplify).
              to eq CFactor[Rat[2, 1], Exp[6, Rat[1, 2]]]
          end
        end

      end

      context 'when a complicated exponent is given' do

        context 'when e.n < e.d' do
          it 'returns a proper CFactor' do
            expect(Exp[144, Rat[2, 3]].simplify).
              to eq CFactor[Rat[12, 1], Exp[12, Rat[1, 3]]]
          end
        end

        context 'when e.n > e.d' do
          it 'returns a proper CFactor' do
            expect(Exp[144, Rat[8, 3]].simplify).
              to eq CFactor[Rat[248832, 1], Exp[12, Rat[1, 3]]]
          end
        end

      end

    end

    describe '#multiply' do

      context 'in ordinary case' do
        it 'returns a correct value' do
          expect(Exp[2, Rat[1, 3]].multiply(Exp[2, Rat[1, 3]])).
            to eq Exp[4, Rat[1, 3]]
        end
      end

      context 'when an incompatible one is given' do
        it 'raises an Error' do
          expect { Exp[2, Rat[1, 3]].multiply(Exp[3, Rat[1, 3]]) }.
            to raise_error(Exponential::ExponentialMultiplicationError)
        end
      end

    end

  end

  describe Logarithm do
    pending
  end


  describe Term do

    describe '#simplify' do

      context 'when the term consists of Rationals' do
        it 'simplifies properly (This is not a simple unit test)' do
          expect(Term[Rat[2, 3], Rat[3, 4]].simplify).
            to eq Term[Rat[1, 2]]
        end
      end

      context 'when the term consists of Exponentials' do
        it 'simplifies properly (This is not a simple unit test)' do
          expect(Term[Exp[2, Rat[1, 3]], Exp[2, Rat[1, 3]]].simplify).
            to eq Term[Exp[4, Rat[1, 3]]]
        end
      end

    end

    describe '#add' do

      context 'when the term consists of Rationals' do
        it 'adds given properly (This is not a simple unit test)' do
          expect(Term[Rat[2, 3], Rat[3, 4]].add(Term[Rat[1, 3]])).
            to eq Term[Rat[5, 6]]
        end
      end

    end

  end

  describe Expression do

    describe '#simplify' do

      context 'when the term consists of Rationals' do
        it 'simplifies properly (This is not a simple unit test)' do
          expect(Expression[Term[Rat[2, 3], Rat[3, 4]],
                            Term[Rat[1, 3]]].simplify).
            to eq Expression[Term[Rat[5, 6]]]
        end
      end

    end

  end
end
