RSpec.describe HsMath::Utils do
  describe "::reduction" do
    it "reduce a b properly" do
      expect(Utils.reduction(2, 4)).to eq [1, 2]
    end
  end

  describe "::factorization" do
    context "when a prime number is given" do
      it "returns proper value" do
        expect(Utils.factorization(11)).to eq ({ 11 => 1 })
      end
    end

    context "when a non-prime number is given" do
      it "returns proper value" do
        expect(Utils.factorization(90)).to eq ({ 2 => 1, 3 => 2, 5 => 1 })
      end
    end

    context "when 0 is given" do
      it "returns {}" do
        expect(Utils.factorization(0)).to eq ({})
      end
    end

    context "when 1 is given" do
      it "returns {}" do
        expect(Utils.factorization(1)).to eq ({})
      end
    end
  end

  describe "::prime_numbers" do
    it "returns the prime number list" do
      expect(Utils.prime_numbers.take(10).force).to eq [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    end
  end
end
