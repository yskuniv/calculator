require_relative './calculator_metacode.rb'


module Calculator
  class OperandTypeMismatchError < TypeError
    def initialize(a, b)
      super("#{b.class.to_s} does not match to #{a.class.to_s}")
    end
  end


  module Comparable
    include OperationDefinerHelper

    define_binary_operation :compare

    alias :== :compare
  end

  module Simplifable
    include OperationDefinerHelper

    define_unary_operation_and_its_destructive_method :simplify

    alias :! :simplify!
  end

  module Multiplable
    include OperationDefinerHelper

    class MultiplicationError < StandardError
    end

    define_binary_operation_and_its_destructive_method :multiply

    alias :* :multiply
  end

  module Addable
    include OperationDefinerHelper

    define_binary_operation_and_its_destructive_method :add

    alias :+ :add
  end


  class Element
    include Comparable, Simplifable

    class << self
      alias :[] :new
    end


    private

    def destruct(nw_)
      raise NotImplementedError.new
    end
  end

  class Calculatable < Element
    def <<(given)
      raise NotImplementedError.new
    end
  end

  class Factor < Calculatable
    include Multiplable


    alias :<< :multiply!
  end

  class PrimeFactor < Factor
    class << self
      def identity
        raise NotImplementedError.new
      end

      def identity?(a)
        compare(a, identity)
      end
    end


    def identity?
      self.class.identity?(self)
    end
  end
end
