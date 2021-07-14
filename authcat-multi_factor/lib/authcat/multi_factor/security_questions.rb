# frozen_string_literal: true

module Authcat
  module MultiFactor
    module SecurityQuestions
      # @return [void]
      def self.included(base)
        gem 'authcat-password'
        require 'authcat/password'

        base.extend ClassMethods
      end

      module ClassMethods
        def has_security_questions(attribute = :security_questions, **opts, &block)
          include Authcat::Password::HasPassword,
                  Authcat::Password::Validators

        end
      end
    end
  end
end
