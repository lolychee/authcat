# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module Password
    module Marcos
      extend ActiveSupport::Concern
      include Authcat::Credential::Marcos

      MACRO_MAPPING = {
        has_password: Association::Attribute,
        has_one_password: Association::HasOne,
        has_many_passwords: Association::HasMany
      }.freeze

      module ClassMethods
        def has_password(name = :password, **opts, &block)
          define_credential!(__method__, name, **opts, &block)
        end

        def has_one_password(name = :password, **opts, &block)
          define_credential!(__method__, name, **opts, &block)
        end

        def has_many_passwords(name = :passwords, **opts, &block)
          define_credential!(__method__, name, **opts, &block)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING[macro_name] || super
        end
      end
    end
  end
end
