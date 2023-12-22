# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module Session
    module Marcos
      def self.included(base)
        base.include Authcat::Credential::Marcos
        base.extend ClassMethods
      end

      MACRO_MAPPING = {
        has_one_session: Association::HasOne,
        has_many_sessions: Association::HasMany
      }.freeze

      module ClassMethods
        def has_one_session(name = :session, **opts, &)
          define_credential!(__method__, name, **opts, &)
        end

        def has_many_sessions(name = :sessions, **opts, &)
          define_credential!(__method__, name, **opts, &)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING.fetch(macro_name) { super }
        end
      end
    end
  end
end
