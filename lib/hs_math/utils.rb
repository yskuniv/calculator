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
        candidates = (2..Float::INFINITY)
        founds = []

        enum = Enumerator.new { |y|
          candidates.each do |c|
            (founds << c; y << c) if founds.all? { |f| c % f != 0 }
          end
        }

        enum
      end

      def is_prime_number?(x)
        l = prime_numbers.take_while { |p| p <= x }

        x == l.last
      end

    end
  end
end
