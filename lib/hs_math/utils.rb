module HsMath
  module Utils
    class << self
      def reduction(a, b)
        r = Rational(a, b)

        [r.numerator, r.denominator]
      end

      def factorize(n)
        res = Hash.new(0)

        quot = n
        ps = prime_numbers
        loop do
          p_ = ps.next

          break if quot < p_

          while quot % p_ == 0
            res[p_] += 1
            quot /= p_
          end
        end

        res
      end

      alias factorization factorize

      def prime_numbers
        (0..).lazy.map { |i| prime_number(i) }
      end

      # define a memoization version of _prime_number()
      proc {
        cache = []
        define_method :prime_number do |i|
          cache[i] ||= _prime_number(i)
        end
      }[]

      def _prime_number(i)
        case i
        when 0
          2
        else
          preds = prime_numbers.take(i).force

          ((preds.last + 1)..)
            .find { |n| preds.all? { |p_| n % p_ != 0 } }
        end
      end
    end
  end
end
