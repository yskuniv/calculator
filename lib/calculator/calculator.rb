require_relative './calculator_base.rb'
require_relative './utils.rb'


module Calculator
  class CFactor < Factor
    class << self
      def generate(c, pf)
        shrink(new(c, pf))
      end

      def shrink(a)
        case
        when a.pf.identity?
          a.c
        when a.c.identity?
          a.pf
        else
          a
        end
      end

      def compare(a, b)
        [a.c, a.pf] == [b.c, b.pf]
      end
    end


    def initialize(c, pf)
      @c = c
      @pf = pf
    end

    attr_reader :c, :pf
    alias :coefficient :c
    alias :prime_factor :pf


    private

    def destruct(nw_)
      @c = nw_.c
      @pf = nw_.pf
    end
  end

  class Rational < PrimeFactor
    include Addable

    class << self
      def identity
        new(1, 1)
      end

      def compare(a, b)
        [a.n, a.d] == [b.n, b.d]
      end

      def simplify(a)
        n_, d_ = CalculatorUtils::reduction(a.n, a.d)

        new(n_, d_)
      end

      def multiply(a, b)
        n_ = a.n * b.n
        d_ = a.d * b.d

        simplify(new(n_, d_))
      end

      def add(a, b)
        n_ = a.n * b.d + b.n * a.d
        d_ = a.d * b.d

        simplify(new(n_, d_))
      end
    end


    def initialize(n, d)
      @n = n
      @d = d
    end

    attr_reader :n, :d
    alias :numerator :n
    alias :denominator :d


    private

    def destruct(nw_)
      @n = nw_.n
      @d = nw_.d
    end
  end

  class Radical < PrimeFactor
    def initialize(i, r)
      @i = i
      @r = r
    end

    attr_reader :i, :r
    alias :index :i
    alias :radicand :r


    private

    def destruct(nw_)
      @i = nw_.i
      @r = nw_.r
    end
  end

  class Exponential < PrimeFactor
    class ExponentialMultiplicationError < MultiplicationError
      def initialize
        super('base not compatible')
      end
    end

    class << self
      def identity
        new(1, Rational.new(1, 1))
      end

      def compare(a, b)
        [a.b, a.e] == [b.b, b.e]
      end

      def simplify(a)
        b = a.b
        e = a.e.simplify

        e_div = e.n / e.d
        e_rem = e.n % e.d

        mcb_ = CalculatorUtils::factorization(b ** e_rem)
                 .reduce({ c: 1, b: 1 }) { |s, (f, n)| s.merge({ c: f ** (n / e.d),
                                                                 b: f ** (n % e.d) }) { |_, a, b| a * b } }

        c_ = b ** e_div * mcb_[:c]
        b_ = mcb_[:b]
        e_ = Rational.new(1, (b_ == 1) ? 1 : e.d)

        CFactor.generate(Rational.new(c_, 1), new(b_, e_))
      end

      def multiply(a, b)
        case
        when a.b == b.b
          b_ = a.b
          e_ = a.e + b.e

          simplify(new(b_, e_))
        else
          raise ExponentialMultiplicationError.new
        end
      end
    end


    def initialize(b, e)
      @b = b
      @e = e
    end

    attr_reader :b, :e
    alias :base :b
    alias :exponent :e


    private

    def destruct(nw_)
      @b = nw_.b
      @e = nw_.e
    end
  end

  class Logarithm < PrimeFactor
    def initialize(b, rn)
      @b = b
      @rn = rn
    end

    attr_reader :b, :rn
    alias :base :b
    alias :real_number :rn


    private

    def destruct(nw_)
      @b = nw_.b
      @rn = nw_.rn
    end
  end


  class Term < Calculatable
    include Addable

    class << self
      def compare(a, b)
        a.factors == b.factors
      end

      def simplify(a)
        a_clsd = classify_factors(a.factors)

        res = a_clsd.map { |_, fs| fs.reduce(&:*) }

        new(*res)
      end

      def add(a, b)
        a_clsd = classify_factors(a.factors)
        b_clsd = classify_factors(b.factors)

        res_clsd = a_clsd.merge(b_clsd) { |_, fs_a, fs_b|
          fs_a_smpd = simplify(new(*fs_a)).factors
          fs_b_smpd = simplify(new(*fs_b)).factors

          fs_a_smpd.first + fs_b_smpd.first
        }

        res = res_clsd.values

        new(*res)
      end


      private

      def classify_factors(factors)
        factors.inject({}) { |s, f| l = s[f.class] ||= []; l << f; s }
      end
    end


    def initialize(*factors)
      @factors = factors
    end

    attr_reader :factors


    private

    def destruct(trm_)
      @factors = trm_.factors
    end
  end

  class Expression < Element
    class << self
      def compare(a, b)
        a.terms == b.terms
      end

      def simplify(a)
        t_ = a.terms.reduce(&:+)

        res = [t_]

        new(*res)
      end
    end


    def initialize(*terms)
      @terms = terms
    end

    attr_reader :terms


    private

    def destruct(expr_)
      @terms = expr_.terms
    end
  end


  # define alias of classes
  Rat = Rational
  Rad = Radical
  Exp = Exponential
  Log = Logarithm
end