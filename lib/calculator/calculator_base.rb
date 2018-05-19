module Calculator
  class Element
    class ElementTypeMismatchError < TypeError
      def initialize(a, b)
        super("#{b.class.to_s} does not match to #{a.class.to_s}")
      end
    end

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
      raise ElementTypeMismatchError.new(self, given) unless self.class == given.class

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

    def destruct(nw_)
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
      def included(cls)
        class << cls
          def add(a, b)
            raise NotImplementedError.new
          end
        end
      end
    end


    def add(given)
      raise ElementTypeMismatchError.new(self, given) unless self.class == given.class

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
    class MultiplicationError < StandardError
    end

    class << self
      def multiply(a, b)
        raise NotImplementedError.new
      end
    end


    def multiply(given)
      raise ElementTypeMismatchError.new(self, given) unless self.class == given.class

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
