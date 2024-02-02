# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module Password
    module Marcos
      def self.included(base)
        base.include Authcat::Credential::Marcos
        base.extend ClassMethods
      end

      module ClassMethods
        MACRO_MAPPING = {
          has_password: Reflections::Attribute,
          has_one_password: Reflections::HasOne,
          has_many_passwords: Reflections::HasMany
        }.freeze

        def has_password(name = :password, **, &)
          define_credential!(__method__, name, **, &)
        end

        def has_one_password(name = :password, **, &)
          define_credential!(__method__, name, **, &)
        end

        def has_many_passwords(name = :passwords, **, &)
          define_credential!(__method__, name, **, &)
        end

        def credential_reflection_class_for(macro_name)
          MACRO_MAPPING.fetch(macro_name) { super }
        end
      end
    end
  end
end
