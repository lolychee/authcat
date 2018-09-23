# frozen_string_literal: true

module Authcat
  module Model
    module Validators
      class PasswordVerifyValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          password_digest = record.__send__(options[:with] || "#{attribute}_digest")

          unless password_digest.respond_to?(:verify) && password_digest.verify(value)
            record.errors[attribute] << (options[:message] || "is not verify")
          end
        end
      end
    end
  end
end
