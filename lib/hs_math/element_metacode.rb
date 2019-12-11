module HsMath
  module OperationDefinerHelper
    def self.included(mod)
      class << mod
        def define_unary_operation(opr_name)
          define_singleton_method(:included) do |cls|
            cls.class_eval do
              define_singleton_method(opr_name) do |_a|
                raise NotImplementedError
              end
            end
          end

          define_method(opr_name) do
            self.class.method(opr_name)[self]
          end
        end

        def define_unary_operation_and_its_destructive_method(opr_name)
          define_unary_operation(opr_name)

          define_method("#{opr_name}!") do
            nw_ = self.class.method(opr_name)[self]

            initialize_with_obj(nw_)

            self
          end
        end

        def define_binary_operation(opr_name)
          define_singleton_method(:included) do |cls|
            cls.class_eval do
              define_singleton_method(opr_name) do |_a, _b|
                raise NotImplementedError
              end
            end
          end

          define_method(opr_name) do |given|
            unless self.class == given.class
              raise OperandTypeMismatchError.new(self, given)
            end

            self.class.method(opr_name)[self, given]
          end
        end

        def define_binary_operation_and_its_destructive_method(opr_name)
          define_binary_operation(opr_name)

          define_method("#{opr_name}!") do |given|
            nw_ = self.class.method(opr_name)[self, given]

            initialize_with_obj(nw_)

            self
          end
        end
      end
    end
  end
end
