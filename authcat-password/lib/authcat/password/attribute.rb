# frozen_string_literal: true

require "dry/container"
require "forwardable"

module Authcat
  module Password
    class Attribute
      attr_reader :model, :attribute_name, :options

      class << self
        extend Forwardable

        def_delegators :registry, :register, :resolve

        # @return [Dry::Container]
        def registry
          @registry ||= Dry::Container.new
        end
      end

      register(:digest) { Digest }
      register(:one_time_password) { OneTimePassword }

      def initialize(model, attribute_name, **options)
        @model = model
        @attribute_name = attribute_name
        @options = options

        extend Array if options[:array]
      end

      def load(value)
        new(value) if valid?(value)
      end

      def dump(value)
        return if value.nil?

        (load(value) || create(value)).to_s
      end

      def setup!
        define_attribute!
        define_class_methods!
        define_instance_methods!
        self
      end

      private

      def define_attribute!
        model.attribute attribute_name do |cast_type|
          ActiveRecord::Type::Serialized.new(cast_type, self)
        end
      end

      def define_instance_methods!
        define_verifier!
      end

      def define_class_methods!
        define_class_getter!
      end

      def define_verifier!
        model.define_model_callbacks :"verify_#{attribute_name}"
        model.class_eval <<~RUBY, __FILE__, __LINE__ + 1
          def verify_#{attribute_name}(value)
            run_callbacks(:verify_#{attribute_name}) do
              #{attribute_name}? && self.class.#{attribute_name}.verify(value, #{attribute_name})
            end
          end
        RUBY
      end

      def define_class_getter!
        attribute = self
        model.define_singleton_method(attribute_name) do
          attribute
        end
      end
    end
  end
end
