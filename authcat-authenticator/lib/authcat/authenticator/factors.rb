# frozen_string_literal: true

module Authcat
  module Authenticator
    module Factors
      def self.included(base)
        base.extend ClassMethods
      end

      class Factor
        def initialize(model, name, **, &)
          @model = model
          @name = name
        end
      end

      module ClassMethods
        def self.extended(base)
          base.class_attribute :authentication_factors, default: {}
        end

        def auth_factors(*names, **, &)
          names.each { |name| define_authentication_factor(name, **, &) }
        end

        def define_authentication_factor(name, **, &)
          Factor.new(self, name, **, &).tap do |factor|
            # factor.setup!
            self.authentication_factors = authentication_factors.merge(name => factor)
          end
        end

        def identify_by(credentials = {})
          key, value = credentials.first
          authentication_factors.fetch(key).identify(value)
        end
      end
    end
  end
end
