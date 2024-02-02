# frozen_string_literal: true

module Authcat
  module Credential
    module Marcos
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        MACRO_MAPPING = {}.freeze

        def self.extended(base)
          base.class_attribute :credential_reflections, default: {}
        end

        def credential_reflection_class_for(macro_name)
          MACRO_MAPPING.fetch(macro_name)
        end

        def define_credential!(macro_name, name, **, &)
          credential_reflection_class_for(macro_name).new(self, name, **, &).tap do |reflection|
            reflection.setup!
            self.credential_reflections = credential_reflections.merge(name => reflection)
          end
        end
      end
    end
  end
end
