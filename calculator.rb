module Calculator
  class FactorBase
    class << self
      alias :[] :new
    end


    def <<(given)
      raise NotImplementedError.new
    end

    def ==(given)
      raise NotImplementedError.new
    end
  end

  class PrimeFactor < FactorBase
  end

  class Factor < FactorBase
    def initialize(c, pf)
      @coefficient = c
      @prime_factor = pf
    end

    attr_reader :coefficient, :prime_factor
  end

  class Rational < PrimeFactor
    def initialize(n, d)
      @numerator = n
      @denominator = d
    end

    def ==(given)
      na, da = simplify_nd(@numerator, @denominator)
      nb, db = simplify_nd(given.numerator, given.denominator)

      [na, da] == [nb, db]
    end

    def simplify
      n_, d_ = simplify_nd(@numerator, @denominator)

      self.class.new(n_, d_)
    end

    def multiply(given)
      n_, d_ = multiply_nds([@numerator, @denominator], [given.numerator, given.denominator])

      self.class.new(n_, d_)
    end

    def simplify!
      r = simplify

      return_with_destruction r
    end

    def multiply!(given)
      r = multiply(given)

      return_with_destruction r
    end

    alias :! :simplify!
    alias :<< :multiply!

    attr_reader :numerator, :denominator


    private

    def simplify_nd(n, d)
      r = Rational(n, d)
      [r.numerator, r.denominator]
    end

    def multiply_nds(nd_a, nd_b)
      na, da = nd_a
      nb, db = nd_b

      n_ = na * nb
      d_ = da * db

      simplify_nd(n_, d_)
    end

    def return_with_destruction(r)
      @numerator, @denominator = r.numerator, r.denominator
      self
    end
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

  # define alias of class
  Rat = Rational
  Rad = Radical
  Exp = Exponential
  Log = Logarithm


  class Term
    class << self
      alias :[] :new
    end


    def initialize(*factors)
      @factors = factors
    end

    def simplify
      fcts_ = simplify_factors(@factors)

      @factors = fcts_

      self
    end

    def <<(given)
      fcts_ = simplify_factors(@factors + given.factors)

      @factors = fcts_

      self
    end

    alias :! :simplify

    attr_reader :factors


    private

    def simplify_factors(factors)
      factors_classified = factors.inject({}) { |s, f| l = s[f.class] ||= []; l << f; s }

      ret = factors_classified.map { |_, fs| fs.reduce(&:<<) }

      ret
    end
  end

  class Expression
    class << self
      alias :[] :new
    end


    def initialize(*terms)
      @terms = terms
    end

    def simplify
      @terms.each(&:simplify)

      simplified = @terms.reduce(&:<<)

      @terms = simplified

      self
    end

    alias :! :simplify
  end
end
