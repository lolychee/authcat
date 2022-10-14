# frozen_string_literal: true

module Authcat
  module Identity
    class Attribute
      attr_reader :model, :attribute_name, :options

      def initialize(model, attribute_name, format: :token, **options)
        @model = model
        @attribute_name = attribute_name
        @formater = format.is_a?(Module) ? format : Formatters.resolve(format)
        @options = options
      end

      def identify(value)
        model.find_by(attribute_name => parse(value))
      end

      def parse(value)
        @formater.parse(value, **options)
      end

      def valid?(value)
        @formater.valid?(value, **options)
      end

      def load(value)
        parse(value) if valid?(value)
      end

      def dump(value)
        return if value.nil?

        load(value).to_s
      end

      def setup!
        define_attribute!
        define_class_methods!
        define_instance_methods!
      end

      private

      def define_attribute!
        model.attribute attribute_name do |cast_type|
          ActiveRecord::Type::Serialized.new(cast_type, self)
        end
      end

      def define_instance_methods!
        # define_identifier!
      end

      def define_class_methods!
        define_class_getter!
      end

      def define_identifier!
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
