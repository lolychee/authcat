# frozen_string_literal: true

require "active_model/validator"

module Authcat
  module Authenticator
    module Validators
      class ChallengeValidator < ActiveModel::EachValidator
        def initialize(options)
          super
          setup!(options[:class])
        end

        def validate_each(record, attribute, value)
          challenge = record.public_send(challenge_attribute_name(attribute))

          return if challenge_value_equal?(record, attribute, value, challenge)

          human_attribute_name = record.class.human_attribute_name(attribute)
          record.errors.add(challenge_attribute_name(attribute), :challenge,
                            **options.except(:case_sensitive).merge!(attribute: human_attribute_name))
        end

        private

        def setup!(klass)
          klass.attr_reader(*attributes.filter_map do |attribute|
            challenge_attribute_name(attribute) unless klass.method_defined?(challenge_attribute_name(attribute))
          end)

          klass.attr_writer(*attributes.filter_map do |attribute|
            challenge_attribute_name(attribute) unless klass.method_defined?(:"#{challenge_attribute_name(attribute)}=")
          end)
        end

        def challenge_attribute_name(attribute)
          :"#{attribute}#{options.fetch(:suffix, "_challenge")}"
        end

        def challenge_value_equal?(record, attribute, _value, challenge)
          record = record.public_send(options[:delegate]) if options[:delegate]

          case options[:with]
          when String, Symbol
            attribute = options[:with]
          end
          attribute = "#{attribute}_was" if options[:was]

          if record.respond_to?(:"verify_#{attribute}")
            record.public_send(:"verify_#{attribute}", challenge)
          else
            value = record.send(attribute)
            if value.respond_to?(:verify)
              value.verify(challenge)
            else
              value == challenge
            end
          end
        end
      end
    end
  end
end
