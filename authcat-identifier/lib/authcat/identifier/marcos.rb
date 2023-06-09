# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module Identifier
    module Marcos
      extend ActiveSupport::Concern
      include Authcat::Credential::Marcos

      MACRO_MAPPING = {
        has_identifier: Association::Attribute,
        has_one_identifier: Association::HasOne,
        has_many_identifiers: Association::HasMany
      }.freeze

      module ClassMethods
        def has_identifier(name, **opts, &block)
          define_credential!(__method__, name, **opts, &block)
        end

        def has_one_identifier(name, **opts, &block)
          define_credential!(__method__, name, **opts, &block)
        end

        def has_many_identifiers(name, **opts, &block)
          define_credential!(__method__, name, **opts, &block)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING[macro_name] || super
        end
      end
    end
  end
end
