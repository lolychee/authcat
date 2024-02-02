# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module IdentityProvider
    module Marcos
      def self.included(base)
        base.include Authcat::Credential::Marcos
        base.extend ClassMethods
      end

      module ClassMethods
        MACRO_MAPPING = {
          has_many_identity_providers: Reflections::HasMany
        }.freeze

        def has_many_identity_providers(name = :identity_providers, **, &)
          define_credential!(__method__, name, **, &)
        end

        def credential_reflection_class_for(macro_name)
          MACRO_MAPPING.fetch(macro_name) { super }
        end
      end
    end
  end
end
