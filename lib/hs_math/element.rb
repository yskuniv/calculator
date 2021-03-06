require "hs_math/element_base"
require "hs_math/utils"

module HsMath
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

    def initialize_with_obj(o)
      @c = o.c
      @pf = o.pf
    end

    def to_s
      "#{@c}*#{@pf}"
    end

    attr_reader :c, :pf
    alias coefficient c
    alias prime_factor pf
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
        n_, d_ = Utils.reduction(a.n, a.d)

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

    def initialize_with_obj(o)
      @n = o.n
      @d = o.d
    end

    def to_s
      @n.to_s + (@d == 1 ? "" : "/#{@d}")
    end

    attr_reader :n, :d
    alias numerator n
    alias denominator d
  end

  class Radical < PrimeFactor
    def initialize(i, r)
      @i = i
      @r = r
    end

    def initialize_with_obj(o)
      @i = o.i
      @r = o.r
    end

    def to_s
      "#{@i}_/#{@r}"
    end

    attr_reader :i, :r
    alias index i
    alias radicand r
  end

  class Exponential < PrimeFactor
    class ExponentialMultiplicationError < MultiplicationError
      def initialize
        super("base not compatible")
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

        mcb_ = Utils.factorization(b**e_rem)
                    .reduce(c: 1, b: 1) { |s, (f, n)|
          s.merge(c: f**(n / e.d),
                  b: f**(n % e.d)) { |_, a, b| a * b }
        }

        c_ = b**e_div * mcb_[:c]
        b_ = mcb_[:b]
        e_ = Rational.new(1, b_ == 1 ? 1 : e.d)

        CFactor.generate(Rational.new(c_, 1), new(b_, e_))
      end

      def multiply(a, b)
        case
        when a.b == b.b
          b_ = a.b
          e_ = a.e + b.e

          simplify(new(b_, e_))
        else
          raise ExponentialMultiplicationError
        end
      end
    end

    def initialize(b, e)
      @b = b
      @e = e
    end

    def initialize_with_obj(o)
      @b = o.b
      @e = o.e
    end

    def to_s
      "#{@b}^#{@e}"
    end

    attr_reader :b, :e
    alias base b
    alias exponent e
  end

  class Logarithm < PrimeFactor
    def initialize(b, rn)
      @b = b
      @rn = rn
    end

    def initialize_with_obj(o)
      @b = o.b
      @rn = o.rn
    end

    def to_s
      "Log#{@b}(#{@rn})"
    end

    attr_reader :b, :rn
    alias base b
    alias real_number rn
  end

  class Term < Calculatable
    include Addable

    class << self
      class ClassifiedFactors
        def initialize(factors)
          @classified = factors_to_classified(factors)
        end

        def [](fct_class)
          @classified[fct_class]
        end

        def map(&block)
          classified_ = new_classified

          @classified.each do |fct_class, fct_lst|
            classified_[fct_class] = block[fct_class, fct_lst]
          end

          @classified = classified_

          self
        end

        def merge(other, &block)
          classified_ = new_classified

          @classified.merge(other.classified) do |fct_class, fct_lst_s, fct_lst_o|
            classified_[fct_class] = block[fct_class, fct_lst_s, fct_lst_o]
          end

          @classified = classified_

          self
        end

        def to_factors
          classified_to_factors(@classified)
        end

        attr_reader :classified

        private

        def factors_to_classified(factors)
          factors.each_with_object(new_classified) { |fct, s| s[fct.class] << fct }
        end

        def classified_to_factors(classified)
          classified.map { |_, fct_lst| fct_lst }.inject(&:+)
        end

        def new_classified
          Hash.new { |h, k| h[k] = [] }
        end
      end

      def compare(a, b)
        a.factors == b.factors
      end

      def simplify(a)
        a_clsd = ClassifiedFactors.new(a.factors)

        res_clsd = a_clsd.map { |_, fct_lst| [fct_lst.map(&:simplify).reduce(&:*)] }

        new(*res_clsd.to_factors)
      end

      def add(a, b)
        a_clsd = ClassifiedFactors.new(a.factors)
        b_clsd = ClassifiedFactors.new(b.factors)

        res_clsd = a_clsd.merge(b_clsd) { |_, fct_lst_a, fct_lst_b|
          t_a = simplify(new(*fct_lst_a))
          t_b = simplify(new(*fct_lst_b))

          t_a.factors.first + t_b.factors.first
        }

        new(*res_clsd.to_factors)
      end
    end

    def initialize(*factors)
      @factors = factors
    end

    def initialize_with_obj(o)
      @factors = o.factors
    end

    def to_s
      @factors.map(&:to_s).join("*").to_s
    end

    attr_reader :factors
  end

  class SubExpression < Factor
    class << self
      def compare(a, b)
        a.terms == b.terms
      end

      def simplify(a)
        t_ = a.terms.map(&:simplify).reduce(&:+)

        res = [t_]

        new(*res)
      end
    end

    def initialize(*terms)
      @terms = terms
    end

    def initialize_with_obj(o)
      @terms = o.terms
    end

    def to_s
      "(#{@terms.map(&:to_s).join(' + ')})"
    end

    attr_reader :terms
  end

  class Expression < Element
    class << self
      def compare(a, b)
        a.sub_expression == b.sub_expression
      end

      def simplify(a)
        sub_expression_ = a.sub_expression.simplify

        new(*sub_expression_.terms)
      end
    end

    def initialize(*terms)
      @sub_expression = SubExpression.new(*terms)
    end

    def initialize_with_obj(o)
      @sub_expression = o.sub_expression
    end

    def to_s
      @sub_expression.terms.map(&:to_s).join(" + ").to_s
    end

    attr_reader :sub_expression
  end

  # define alias of classes
  Rat = Rational
  Rad = Radical
  Exp = Exponential
  Log = Logarithm
end
