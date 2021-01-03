# frozen_string_literal: true

require 'dry/container'
require 'forwardable'

module Authcat
  module Identity
    class Type
      class << self
        extend Forwardable

        def_delegators :registry, :register, :resolve

        def registry
          @registry ||= Dry::Container.new
        end
      end

      def initialize; end

      register(:email) { Email }
      register(:phone_number) { PhoneNumber }
      register(:token) { Token }
      register(:username) { Username }
    end
  end
end
