# frozen_string_literal: true

require "active_model/validator"

module Authcat
  class Password
    module Validators
      class AttemptValidator < ActiveModel::EachValidator
        def initialize(options)
          super
          setup!(options[:class])
        end

        def validate_each(record, attribute, value)
          attempt = record.public_send("#{attribute}_attempt")
          passed =
            if record.respond_to?("verify_#{attribute}")
              record.public_send("verify_#{attribute}", attempt)
            else
              !value.nil? && value == attempt
            end

          record.errors.add(:"#{attribute}_attempt", :incorrect, **options.slice(:message)) unless passed
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
