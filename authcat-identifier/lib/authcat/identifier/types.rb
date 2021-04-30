# frozen_string_literal: true

require 'dry/container'
require 'forwardable'
# require 'activemodel/attribute_methods'

module Authcat
  module Identifier
    module Types
      class << self
        extend Forwardable

        def_delegators :registry, :register, :resolve

        def registry
          @registry ||= Dry::Container.new
        end
      end

      register(:email) { Email }
      register(:phone_number) { PhoneNumber }
      register(:token) { Token }
      register(:username) { Username }
      register(:omniauth) { Omniauth }
    end
  end
end
