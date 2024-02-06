# frozen_string_literal: true

module Authcat
  module Authenticator
    module Factors
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def self.extended(base)
          base.class_attribute :authentication_factors, default: {}
        end

        def auth_factors(*names, **, &)
          names.each { |name| auth_factor(name, **, &) }
        end

        def auth_factor(name, **, &)
          define_auth_factor(name, **, &)
        end

        def define_auth_factor(name, **, &)
          auth_factor_class_for(name, **).new(self, name, **, &).tap do |factor|
            # factor.setup!
            self.authentication_factors = authentication_factors.merge(name => factor)
          end
        end

        def auth_factor_class_for(_name, **)
          AttributeFactor
        end

        def identify_by(credentials = {})
          raise ArgumentError, "Unsupport multi identifiers" if credentials.size > 1

          name, value = credentials.first
          authentication_factors.fetch(name).identify(value)
        end
      end

      def issue_factor(name, **, &)
        self.class.authentication_factors.fetch(name).issue(self, **, &)
      end
    end
  end
end
