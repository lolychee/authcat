# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module Session
    module Marcos
      extend ActiveSupport::Concern
      include Authcat::Credential::Marcos

      MACRO_MAPPING = {
        has_one_session: Association::HasOne,
        has_many_sessions: Association::HasMany
      }.freeze

      module ClassMethods
        def has_one_session(name = :session, **opts, &block)
          define_credential!(__method__, name, **opts, &block)
        end

        def has_many_sessions(name = :sessions, **opts, &block)
          define_credential!(__method__, name, **opts, &block)
        end

        def lookup_credential_klass(macro_name)
          MACRO_MAPPING[macro_name] || super
        end
      end
    end
  end
end
