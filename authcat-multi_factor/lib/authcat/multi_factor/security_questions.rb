# frozen_string_literal: true

module Authcat
  module MultiFactor
    module SecurityQuestions
      # @return [void]
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def has_security_questions(_attribute = :security_questions, **_opts)
        end
      end
    end
  end
end
