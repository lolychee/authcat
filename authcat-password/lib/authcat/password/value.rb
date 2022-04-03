 require 'delegate'

module Authcat
  module Password
    class Value < DelegateClass(::String)
        # @return [Crypto]
      attr_reader :crypto

      # @return [self]
      def initialize(ciphertext, crypto:, **opts)
        @crypto = Crypto.build(crypto, ciphertext, **opts)
        super(ciphertext)
      end

      # @return [Boolean]
      def verify(other, **opts)
        @crypto.verify(self, other, **opts)
      end

      alias == verify
    end
  end
end
