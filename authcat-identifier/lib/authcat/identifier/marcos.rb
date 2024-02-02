# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module Identifier
    module Marcos
      def self.included(base)
        base.include Authcat::Credential::Marcos
        base.extend ClassMethods
      end

      module ClassMethods
        MACRO_MAPPING = {
          has_identifier: Reflections::Attribute,
          has_one_identifier: Reflections::HasOne,
          has_many_identifiers: Reflections::HasMany
        }.freeze

        def has_identifier(name, **, &)
          define_credential!(__method__, name, **, &)
        end

        def has_one_identifier(name, **, &)
          define_credential!(__method__, name, **, &)
        end

        def has_many_identifiers(name, **, &)
          define_credential!(__method__, name, **, &)
        end

        def credential_reflection_class_for(macro_name)
          MACRO_MAPPING.fetch(macro_name) { super }
        end
      end
    end
  end
end
