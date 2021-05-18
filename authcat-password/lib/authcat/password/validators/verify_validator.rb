# frozen_string_literal: true

require "active_model/validator"

module Authcat
  class Password
    module Validators
      class VerifyValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          with = options[:with] || attribute
          passed =
            if record.respond_to?("verify_#{with}")
              record.public_send("verify_#{with}", value)
            else
              !value.nil? && record.public_send(with) == value
            end

          record.errors.add(attribute, :incorrect, **options.slice(:message)) unless passed
        end
      end
    end
  end
end
