require "active_model/validator"

module Authcat
  class Password
    module Validators
      class AuthenticateValidator < ActiveModel::EachValidator
        def initialize(options)
          super
          setup!(options[:class])
        end

        def validate_each(record, attribute, value)
          suffix = options[:suffix] || "_attempt"
          with = options[:with] || "#{attribute}#{suffix}"

          attempt_value = record.send(with)
          authenticated =
            if record.respond_to?(:authenticate)
              record.authenticate({ attribute => attempt_value })
            else
              value == attempt_value
            end

          record.errors.add(attribute, :unauthenticated, **options.slice(:message)) unless authenticated
        end

        private

        def setup!(klass)
          klass.attr_reader(*attributes.map do |attribute|
            :"#{attribute}_attempt" unless klass.method_defined?(:"#{attribute}_attempt")
          end.compact)

          klass.attr_writer(*attributes.map do |attribute|
            :"#{attribute}_attempt" unless klass.method_defined?(:"#{attribute}_attempt=")
          end.compact)
        end
      end
    end
  end
end
