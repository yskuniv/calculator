module HsMath
  module Utils
    class << self
      def reduction(a, b)
        r = Rational(a, b)

        [r.numerator, r.denominator]
      end

      def factorization(a)
        t_c = a
        res = Hash.new(0)
        pnums = prime_numbers

        loop do
          p_c = pnums.next

          break if t_c < p_c

          while t_c % p_c == 0
            res[p_c] += 1
            t_c /= p_c
          end
        end

        res
      end

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
