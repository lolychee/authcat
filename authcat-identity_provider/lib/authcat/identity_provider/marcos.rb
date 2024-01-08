# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module IdentityProvider
    module Marcos
      def self.included(base)
        base.include Authcat::Credential::Marcos
        base.extend ClassMethods
      end

      MACRO_MAPPING = {
        has_many_identity_providers: Association::HasMany
      }.freeze

      module ClassMethods
        def has_many_identity_providers(name = :identity_providers, **, &)
          define_credential!(__method__, name, **, &)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING.fetch(macro_name) { super }
        end
      end
    end
  end
end
