# frozen_string_literal: true

require "active_model/validator"

module Authcat
  module Identity
    module Validators
      class IdentifyValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          identify_method_name = [:identify, options[:with]].compact.join("_")
          identity = record.public_send(identify_method_name, value, **options.slice(:only, :except))

          record.errors.add(attribute, :not_found, **options.slice(:message)) unless identity
        end
      end
    end
  end
end
