# frozen_string_literal: true

module Authcat
  module Password
    module Verifiedable
      attr_reader :last_verified_at

      def last_verified?
        !@last_verified_at.nil?
      end

      def last_verified=(value)
        @last_verified_at = value ? Time.now : nil
      end

      def ==(*)
        super.tap {|verified| self.last_verified = verified }
      end

      def verify(*)
        super.tap {|verified| self.last_verified = verified }
      end
    end
  end
end
