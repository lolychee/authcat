# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module IdP
    module Marcos
      def self.included(base)
        base.include Authcat::Credential::Marcos
        base.extend ClassMethods
      end

      MACRO_MAPPING = {
        has_many_idp_credentials: Association::HasMany
      }.freeze

      module ClassMethods
        def has_many_idp_credentials(name = :idp_credentials, **opts, &)
          define_credential!(__method__, name, **opts, &)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING[macro_name] || super
        end
      end
    end
  end
end
