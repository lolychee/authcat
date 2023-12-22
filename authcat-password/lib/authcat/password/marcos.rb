# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module Password
    module Marcos
      def self.included(base)
        base.include Authcat::Credential::Marcos
        base.extend ClassMethods
      end

      MACRO_MAPPING = {
        has_password: Association::Attribute,
        has_one_password: Association::HasOne,
        has_many_passwords: Association::HasMany
      }.freeze

      module ClassMethods
        def has_password(name = :password, **opts, &)
          define_credential!(__method__, name, **opts, &)
        end

        def has_one_password(name = :password, **opts, &)
          define_credential!(__method__, name, **opts, &)
        end

        def has_many_passwords(name = :passwords, **opts, &)
          define_credential!(__method__, name, **opts, &)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING.fetch(macro_name) { super }
        end
      end
    end
  end
end
