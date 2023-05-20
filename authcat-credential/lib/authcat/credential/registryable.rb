# frozen_string_literal: true

require "dry/container"

module Authcat
  module Credential
    module Registryable
      extend ActiveSupport::Concern

      module ClassMethods
        def registry
          @registry ||= Dry::Container.new
        end

        def register(...)
          registry.register(...)
        end

        def resolve(...)
          registry.resolve(...)
        end
      end
    end
  end
end
