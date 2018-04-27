module Calculator
  class Element
    class << self
      def [](*args)
        params_ = generate_params(*args)

        new(params_)
      end

      def generate_params(*args)
        raise NotImplementedError.new
      end

      def compare_2params(a, b)
        raise NotImplementedError.new
      end

      def simplify_params(a)
        raise NotImplementedError.new
      end
    end


    def initialize(params_)
      @params = params_
    end

    def compare(given)
      return false if given.nil?

      self.class.compare_2params(@params, given.params)
    end

    def simplify
      params_ = self.class.simplify_params(@params)

      self.class.new(params_)
    end

    def simplify!
      params_ = self.class.simplify_params(@params)

      @params = params_

      self
    end

    alias :== :compare
    alias :! :simplify!

    attr_reader :params
  end

  class Calculatable < Element
    def <<(given)
      raise NotImplementedError.new
    end
  end

  module Addable
    class << self
      def add_2params(a, b)
        raise NotImplementedError.new
      end
    end

    def add(given)
      params_ = self.class.add_2params(@params, given.params)

      self.class.new(params_)
    end

    def add!(given)
      params_ = self.class.add_2params(@params, given.params)

      @params = params_

      self
    end

    alias :+ add
  end

  class Factor < Calculatable
    class << self
      def multiply_2params(a, b)
        raise NotImplementedError.new
      end
    end

    def multiply(given)
      params_ = self.class.multiply_2params(@params, given.params)

      self.class.new(params_)
    end

    def multiply!(given)
      params_ = self.class.multiply_2params(@params, given.params)

      @params = params_

      self
    end

    alias :* :multiply
    alias :<< :multiply!
  end

  class CFactor < Factor
    def initialize(c, pf)
      @coefficient = c
      @prime_factor = pf
    end

    attr_reader :coefficient, :prime_factor
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

        generate_params(r.numerator, r.denominator)
      end

      def multiply_2params(a, b)
        n_ = a[:n] * b[:n]
        d_ = a[:d] * b[:d]

        simplify_params(generate_params(n_, d_))
      end

      def add_2params(a, b)
        n_ = a[:n] * b[:d] + b[:n] * a[:d]
        d_ = a[:d] * b[:d]

        simplify_params(generate_params(n_, d_))
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


  class Term < Calculatable
    include Addable

    def initialize(*factors)
      @factors = factors
    end

    def ==(given)
      return false if given.nil?

      @factors == given.factors
    end

    def simplify
      fcts_ = simplify_factors(@factors)

      self.class.new(*fcts_)
    end

    def add(given)
      return self.class.new(@factors) if given.nil?

      fcts_ = add_2factors(@factors, given.factors)

      self.class.new(*fcts_)
    end

    alias :<< :add!

    attr_reader :factors


    private

    def simplify_factors(factors)
      cfactors = classify_factors(factors)

      cfactors.map { |_, fs| fs.reduce(&:*) }
    end

    def add_2factors(factors_a, factors_b)
      cfactors_a = classify_factors(factors_a)
      cfactors_b = classify_factors(factors_b)

      cfcts_ = cfactors_a.merge(cfactors_b) { |_, fs_a, fs_b| simplify_factors(fs_a).first + simplify_factors(fs_b).first }

      cfcts_.values
    end

    def classify_factors(factors)
      factors.inject({}) { |s, f| l = s[f.class] ||= []; l << f; s }
    end

    def destruct_self_with(t)
      @factors = t.factors
    end
  end

  class Expression < Element
    def initialize(*terms)
      @terms = terms
    end

    def ==(given)
      return false if given.nil?

      @terms == given.terms
    end

    def simplify
      trms_ = simplify_terms(@terms)

      self.class.new(*trms_)
    end

    attr_reader :terms


    private

    def simplify_terms(terms)
      t_ = terms.reduce(&:+)
      [t_]
    end

    def destruct_self_with(e)
      @terms = e.terms
    end
  end


  # define alias of classes
  Rat = Rational
  Rad = Radical
  Exp = Exponential
  Log = Logarithm
end
