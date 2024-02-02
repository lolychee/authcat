# frozen_string_literal: true

require "authcat/support"

module Authcat
  module Authenticator
    module Providers
      include Authcat::Support::ActsAsRegistry

      register(:headers) { Headers }
      register(:http_authentication) { HttpAuthentication }
      register(:cookie) { Cookie }
      register(:session) { Session }
      register(:params) { Params }

      def providers
        @providers ||= {}
      end

      def provider(name, *, **, &)
        klass = Providers.resolve(name)
        providers[name] = klass.new(*, **, &)
      end
    end
  end
end
