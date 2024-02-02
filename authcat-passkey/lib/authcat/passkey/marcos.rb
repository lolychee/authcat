# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module Passkey
    module Marcos
      def self.included(base)
        base.include Authcat::Credential::Marcos
        base.extend ClassMethods
      end

      module ClassMethods
        MACRO_MAPPING = {
          has_many_passkeys: Reflections::HasMany
        }.freeze

        def has_many_passkeys(name = :passkeys, **, &)
          define_credential!(__method__, name, **, &)
        end

        def credential_reflection_class_for(macro_name)
          MACRO_MAPPING.fetch(macro_name) { super }
        end
      end
    end
  end
end
