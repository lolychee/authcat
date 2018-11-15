# frozen_string_literal: true

module Authcat
  module Password
    module Validators
      if defined?(ActiveModel) && defined?(ActiveModel::EachValidator)

        class PasswordVerifyValidator < ActiveModel::EachValidator
          def validate_each(record, attribute, value)
            passed = if options[:with]
              record.__send__(options[:with]) == value
            else
              if record.respond_to?("#{attribute}_verify")
                record.__send__("#{attribute}_verify", value)
              else
                record.__send__("#{attribute}_digest") == value
              end
            end

            record.errors[attribute] << (options[:message] || "is not verify") unless passed
          end
        end

      end
    end
  end
end
