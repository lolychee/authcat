module Authcat
  class Password
    class Collection < Array
      class << self
        def create(unencrypted_strs, algorithm:, **opts)
          return unless unencrypted_strs.respond_to?(:to_a)

          algorithm = Algorithm.build(algorithm, **opts)

          new(unencrypted_strs.to_a.map { |unencrypted_str| Password.create(unencrypted_str, algorithm: algorithm, **opts) }, algorithm: algorithm, **opts)
        end
      end

      def initialize(*args, algorithm:, **opts, &block)
        @algorithm = Algorithm.build(algorithm, **opts)

        super(*args, &block)
        each { |encrypted_str| @algorithm.valid!(encrypted_str) }
      end

      def verify(other)
        any? { |pwd| pwd == other }
      end
      alias == verify
    end
  end
end
