# frozen_string_literal: true

require 'dry/container'
require 'forwardable'

module Authcat
  class Passport
    class Provider
      class << self
        extend Forwardable

        def_delegators :registry, :register, :resolve

        def registry
          @registry ||= Dry::Container.new
        end
      end

      register(:cookies) { Cookies }
      register(:header) { Header }
      register(:http_authentication) { HttpAuthentication }
      register(:omniauth) { Omniauth }
      register(:params) { Params }
      register(:session) { Session }
    end
  end
end
