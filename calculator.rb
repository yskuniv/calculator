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
      na, da = reduction(@numerator, @denominator)
      nb, db = reduction(given.numerator, given.denominator)

      [na, da] == [nb, db]
    end

    def simplify
      n_, d_ = reduction(@numerator, @denominator)

      self.class.new(n_, d_)
    end

    def <<(given)
      nn = @numerator * given.numerator
      dd = @denominator * given.denominator

      n_, d_ = reduction(nn, dd)

      @numerator, @denominator = n_, d_

      self
    end

    alias :! :simplify

    attr_reader :numerator, :denominator


    private

    def reduction(n, d)
      r = Rational(n, d)
      [r.numerator, r.denominator]
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
