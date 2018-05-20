module Calculator
  module OperationDefinerHelper
      def self.included(mod)
        class << mod
          def define_unary_operation(opr_name)
            define_singleton_method(:included) do |cls|
              cls.class_eval do
                define_singleton_method(opr_name) do |a|
                  raise NotImplementedError.new
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
              elm_ = self.class.method(opr_name)[self]

              destruct(elm_)

              self
            end

            define_destruct
          end

          def define_binary_operation(opr_name)
            define_singleton_method(:included) do |cls|
              cls.class_eval do
                define_singleton_method(opr_name) do |a, b|
                  raise NotImplementedError.new
                end
              end
            end


            define_method(opr_name) do |given|
              raise OperandTypeMismatchError.new(self, given) unless self.class == given.class

              self.class.method(opr_name)[self, given]
            end
          end

          def define_binary_operation_and_its_destructive_method(opr_name)
            define_binary_operation(opr_name)

            define_method("#{opr_name}!") do |given|
              elm_ = self.class.method(opr_name)[self, given]

              destruct(elm_)

              self
            end

            define_destruct
          end


          private

          def define_destruct
            define_method(:destruct) do |elm_|
              raise NotImplementedError.new
            end
          end
        end
      end
  end
end
