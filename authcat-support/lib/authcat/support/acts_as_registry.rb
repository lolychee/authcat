# frozen_string_literal: true

require "dry/container"

module Authcat
  module Support
    module ActsAsRegistry
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def registry
          @registry ||= Dry::Container.new
        end

        def register(...)
          registry.register(...)
        end

        def resolve(...)
          registry.resolve(...).then do |value|
            block_given? ? yield(value) : value
          end
        end
      end
    end
  end
end
