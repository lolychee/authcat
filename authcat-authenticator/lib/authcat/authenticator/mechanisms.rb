# frozen_string_literal: true

module Authcat
  module Authenticator
    module Mechanisms
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def self.extended(base)
          base.class_attribute :authentication_mechanisms, default: {}
        end

        def define_authentication_mechanism(name, **, &)
          Mechanism.new(self, name, **, &).tap do |mechanism|
            mechanism.setup!
            self.authentication_mechanisms = authentication_mechanisms.merge(name => mechanism)
          end
        end
      end
    end
  end
end
