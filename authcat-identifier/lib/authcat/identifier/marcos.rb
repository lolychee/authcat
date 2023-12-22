# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module Identifier
    module Marcos
      MACRO_MAPPING = {
        has_identifier: Association::Attribute,
        has_one_identifier: Association::HasOne,
        has_many_identifiers: Association::HasMany
      }.freeze

      def self.included(base)
        base.include Authcat::Credential::Marcos
        base.extend ClassMethods
      end

      module ClassMethods
        def has_identifier(name, **opts, &)
          define_credential!(__method__, name, **opts, &)
        end

        def has_one_identifier(name, **opts, &)
          define_credential!(__method__, name, **opts, &)
        end

        def has_many_identifiers(name, **opts, &)
          define_credential!(__method__, name, **opts, &)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING.fetch(macro_name) { super }
        end
      end
    end
  end
end
