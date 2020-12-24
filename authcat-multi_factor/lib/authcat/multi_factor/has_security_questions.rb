# frozen_string_literal: true

module Authcat
  module MultiFactor
    module HasSecurityQuestions
      # @return [void]
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def has_security_questions(attribute = :security_questions, **opts, &block); end
      end
    end
  end
end
