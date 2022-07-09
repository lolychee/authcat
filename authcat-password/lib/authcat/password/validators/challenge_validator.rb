# frozen_string_literal: true

require "active_model/validator"

module Authcat
  module Password
    module Validators
      class ChallengeValidator < ActiveModel::EachValidator
        def initialize(options)
          super
          setup!(options[:class])
        end

        def validate_each(record, attribute, value)
          if !(challenge = record.public_send("#{attribute}_challenge")).nil? && !challenge_value_equal?(record,
                                                                                                         attribute, value, challenge)
            human_attribute_name = record.class.human_attribute_name(attribute)
            record.errors.add(:"#{attribute}_challenge", :challenge,
                              **options.except(:case_sensitive).merge!(attribute: human_attribute_name))
          end
        end

        private

        def setup!(klass)
          klass.attr_reader(*attributes.map do |attribute|
            :"#{attribute}_challenge" unless klass.method_defined?(:"#{attribute}_challenge")
          end.compact)

          klass.attr_writer(*attributes.map do |attribute|
            :"#{attribute}_challenge" unless klass.method_defined?(:"#{attribute}_challenge=")
          end.compact)
        end

        def challenge_value_equal?(record, attribute, _value, challenge)
          attribute = "#{attribute}_was" if options[:was]

          if record.respond_to?("verify_#{attribute}")
            record.public_send("verify_#{attribute}", challenge)
          else
            record.send(attribute) == challenge
          end
        end
      end
    end
  end
end
