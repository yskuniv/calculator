module Calculator
class PrimeFactor
  def <<(x)
    raise NotImplementedError.new
  end
end

class Rational < PrimeFactor
  def initialize(n, d)
    @numerator = n
    @denominator = d
  end

  attr_reader :numerator, :denominator
end

class Radical < PrimeFactor
  def initialize(i, r)
    @index = i
    @radicand = r
  end

  attr_reader :index, :radicand
end

class Exponential < PrimeFactor
  def initialize(b, e)
    @base = b
    @exponent = e
  end

  attr_reader :base, :exponent
end

class Logarithm < PrimeFactor
  def initialize(b, n)
    @base = b
    @real_number = n
  end

  attr_reader :base, :real_number
end


class Term
  def initialize(factors)
    @factors = factors
  end

  def simplify
    classify

    simplified = @classified_factors_list.map { |factors|
      factors.reduce(&:<<)
    }

    @factors = simplified
  end


  private

  def classify
    @classified_factors_list = [
      @factors.select { |x| x.is_a? Rational },
      @factors.select { |x| x.is_a? Radical },
      @factors.select { |x| x.is_a? Exponential },
      @factors.select { |x| x.is_a? Logarithm },
    ]
  end
end

class Expression
  def initialize(terms)
    @terms = terms
  end

  def simplify
    @terms.each(&:simplify)

    # do simplification of expression its own here

  end
end
end
