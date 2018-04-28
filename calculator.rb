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
      elm_ = self.class.simplifyc(self)

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
    class << self
      def generate_params(c, pf)
        { c: c, pf: pf }
      end
    end


    def coefficient
      @params[:c]
    end

    def prime_factor
      @params[:pf]
    end
  end

  class PrimeFactor < Factor
  end

  class Rational < PrimeFactor
    include Addable

    class << self
      def generate_params(n, d)
        { n: n, d: d }
      end

      def compare_2params(a, b)
        [a[:n], a[:d]] == [b[:n], b[:d]]
      end

      def simplify_params(a)
        r = Rational(a[:n], a[:d])

        to_p(r.numerator, r.denominator)
      end

      def multiply_2params(a, b)
        n_ = a[:n] * b[:n]
        d_ = a[:d] * b[:d]

        simplify_params(to_p(n_, d_))
      end

      def add_2params(a, b)
        n_ = a[:n] * b[:d] + b[:n] * a[:d]
        d_ = a[:d] * b[:d]

        simplify_params(to_p(n_, d_))
      end
    end


    def numerator
      @params[:n]
    end

    def denominator
      @params[:d]
    end
  end

  class Radical < PrimeFactor
    class << self
      def generate_params(i, r)
        { i: i, r: r }
      end
    end


    def index
      @params[:i]
    end

    def radicand
      @params[:r]
    end
  end

  class Exponential < PrimeFactor
    class << self
      def generate_params(b, e)
        { b: b, e: e }
      end
    end


    def base
      @params[:b]
    end

    def exponent
      @params[:e]
    end
  end

  class Logarithm < PrimeFactor
    class << self
      def generate_params(b, rn)
        { b: b, rn: rn }
      end
    end


    def base
      @params[:b]
    end

    def real_number
      @params[:rn]
    end
  end


  class Term < Calculatable
    include Addable

    class << self
      def generate_params(*factors)
        { factors: factors }
      end

      def compare_2params(a, b)
        a[:factors] == b[:factors]
      end

      def simplify_params(a)
        a_clsd = classify_factors(a[:factors])

        res = a_clsd.map { |_, fs| fs.reduce(&:*) }

        to_p(*res)
      end

      def add_2params(a, b)
        a_clsd = classify_factors(a[:factors])
        b_clsd = classify_factors(b[:factors])

        res_clsd = a_clsd.merge(b_clsd) { |_, fs_a, fs_b|
          fs_a_smpd = simplify_params(to_p(*fs_a))[:factors]
          fs_b_smpd = simplify_params(to_p(*fs_b))[:factors]

          fs_a_smpd.first + fs_b_smpd.first
        }

        res = res_clsd.values

        to_p(*res)
      end


      private

      def classify_factors(factors)
        factors.inject({}) { |s, f| l = s[f.class] ||= []; l << f; s }
      end
    end


    def factors
      @params[:factors]
    end
  end

  class Expression < Element
    class << self
      def generate_params(*terms)
        { terms: terms }
      end

      def compare_2params(a, b)
        a[:terms] == b[:terms]
      end

      def simplify_params(a)
        t_ = a[:terms].reduce(&:+)

        res = [t_]

        to_p(*res)
      end
    end


    def terms
      @params[:terms]
    end
  end


  # define alias of classes
  Rat = Rational
  Rad = Radical
  Exp = Exponential
  Log = Logarithm
end
