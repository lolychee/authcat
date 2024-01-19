# frozen_string_literal: true

module Authcat
  module Credential
    module Marcos
      MACRO_MAPPING = {}.freeze

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def self.extended(base)
          base.class_attribute :credential_reflections
          base.credential_reflections = {}
        end

        def lookup_credential_reflection_class(macro_name)
          MACRO_MAPPING.fetch(macro_name)
        end

        def define_credential!(macro_name, name, **, &)
          lookup_credential_reflection_class(macro_name).new(self, name, **, &).tap do |reflection|
            reflection.setup!
            self.credential_reflections = credential_reflections.merge(name => reflection)
          end
        end
      end
    end
  end
end
