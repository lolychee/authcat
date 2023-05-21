# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module IdP
    module Marcos
      extend ActiveSupport::Concern
      include Authcat::Credential::Marcos

      MACRO_MAPPING = {
        has_many_idp_credentials: Association::HasMany
      }.freeze

      module ClassMethods
        def has_many_idp_credentials(name = :idp_credentials, **opts, &block)
          define_credential!(__method__, name, **opts, &block)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING[macro_name] || super
        end
      end
    end
  end
end
