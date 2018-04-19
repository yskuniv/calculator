class Rational
  def initialize(n, d)
    @numerator = n
    @denominator = d
  end

  attr_reader :numerator, :denominator
end

class Radical
  def initialize(i, r)
    @index = i
    @radicand = r
  end

  attr_reader :index, :radicand
end

class Exponential
  def initialize(b, e)
    @base = b
    @exponent = e
  end

  attr_reader :base, :exponent
end

class Logarithm
  def initialize(b, n)
    @base = b
    @real_number = n
  end

  attr_reader :base, :real_number
end

class Term
  def initialize(c, rad, exp, log)
    @coefficient = c
    @radical = rad
    @exponential = exp
    @logarithm = log
  end
end

class Expression
  def initialize(terms)
    @terms = terms
  end
end
