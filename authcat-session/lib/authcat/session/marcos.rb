# frozen_string_literal: true

require "authcat/credential"

module Authcat
  module Session
    module Marcos
      def self.included(base)
        base.include Authcat::Credential::Marcos
        base.extend ClassMethods
      end

      module ClassMethods
        MACRO_MAPPING = {
          has_one_session: Reflections::HasOne,
          has_many_sessions: Reflections::HasMany
        }.freeze

        def has_one_session(name = :session, **, &)
          define_credential!(__method__, name, **, &)
        end

        def has_many_sessions(name = :sessions, **, &)
          define_credential!(__method__, name, **, &)
        end

        def credential_reflection_class_for(macro_name)
          MACRO_MAPPING.fetch(macro_name) { super }
        end
      end
    end
  end
end
