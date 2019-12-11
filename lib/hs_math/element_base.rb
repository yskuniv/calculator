require "hs_math/element_metacode"
require "hs_math/error"

module HsMath
  class OperandTypeMismatchError < TypeError
    def initialize(a, b)
      super("#{b.class} does not match to #{a.class}")
    end
  end

  module Comparable
    include OperationDefinerHelper

    define_binary_operation :compare

    alias == compare
  end

  module Simplifable
    include OperationDefinerHelper

    define_unary_operation_and_its_destructive_method :simplify

    alias ! simplify!
  end

  module Multiplable
    include OperationDefinerHelper

    class MultiplicationError < Error
    end

    define_binary_operation_and_its_destructive_method :multiply

    alias * multiply
  end

  module Addable
    include OperationDefinerHelper

    class AdditionError < Error
    end

    define_binary_operation_and_its_destructive_method :add

    alias + add
  end

  class Element
    include Simplifable
    include Comparable

    class << self
      alias [] new
    end

    def initialize_with_obj(_o)
      raise NotImplementedError
    end
  end

  class Calculatable < Element
    def <<(_given)
      raise NotImplementedError
    end
  end

  class Factor < Calculatable
    include Multiplable

    alias << multiply!
  end

  class PrimeFactor < Factor
    class << self
      def identity
        raise NotImplementedError
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
