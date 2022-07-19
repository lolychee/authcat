# frozen_string_literal: true

module Authcat
  module Password
    module Verifiedable
      attr_reader :last_verified_at

      def last_verified?
        !@last_verified_at.nil?
      end

      def ==(*)
        super.tap do |verified|
          @last_verified_at = verified ? Time.now : nil
        end
      end

      def verify(*)
        super.tap do |verified|
          @last_verified_at = verified ? Time.now : nil
        end
      end
    end
  end
end
