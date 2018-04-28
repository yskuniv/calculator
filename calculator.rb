module Calculator
  class Element
    class << self
      def compare(a, b)
        raise NotImplementedError.new
      end

      def simplify(a)
        raise NotImplementedError.new
      end

      alias :[] :new
    end


    def compare(given)
      return false if given.nil?

      self.class.compare(self, given)
    end

    def simplify
      self.class.simplify(self)
    end

    def simplify!
      elm_ = self.class.simplify(self)

      destruct(elm_)

      self
    end

    alias :== :compare
    alias :! :simplify!


    private

    def destruct(elm_)
      raise NotImplementedError.new
    end
  end

  class Calculatable < Element
    def <<(given)
      raise NotImplementedError.new
    end
  end

  module Addable
    class << self
      def add(a, b)
        raise NotImplementedError.new
      end
    end

    def add(given)
      self.class.add(self, given)
    end

    def add!(given)
      add_ = self.class.add(self, given)

      destruct(add_)

      self
    end

    alias :+ add
  end

  class Factor < Calculatable
    class << self
      def multiply(a, b)
        raise NotImplementedError.new
      end
    end

    def multiply(given)
      self.class.multiply(self, given)
    end

    def multiply!(given)
      fct_ = self.class.multiply(self, given)

      destruct(fct_)

      self
    end

    alias :* :multiply
    alias :<< :multiply!
  end

  class CFactor < Factor
    def initialize(c, pf)
      @c = c
      @pf = pf
    end

    attr_reader :c, :pf
    alias :coefficient :c
    alias :prime_factor :pf
  end

  class PrimeFactor < Factor
  end

  class Rational < PrimeFactor
    include Addable

    class << self
      def compare(a, b)
        [a.n, a.d] == [b.n, b.d]
      end

      def simplify(a)
        r = Rational(a.n, a.d)

        new(r.numerator, r.denominator)
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

    def destruct(r)
      @n = r.n
      @d = r.d
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
  end

  class Exponential < PrimeFactor
    def initialize(b, e)
      @b = b
      @e = e
    end

    attr_reader :b, :e
    alias :base :b
    alias :exponent :e
  end

  class Logarithm < PrimeFactor
    def initialize(b, rn)
      @b = b
      @rn = rn
    end

    attr_reader :b, :rn
    alias :base :b
    alias :real_number :rn
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
