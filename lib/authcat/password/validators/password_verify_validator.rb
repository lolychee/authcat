# frozen_string_literal: true

module Authcat
  module Password
    module Validators
      if defined?(ActiveModel) && defined?(ActiveModel::EachValidator)

        class PasswordVerifyValidator < ActiveModel::EachValidator
          def validate_each(record, attribute, value)
            column_name = (options[:with] || attribute).to_s
            column_name += record.class.try(:password_suffix).to_s
            column_name += "_was" if options[:was]

            record.errors[attribute] << (options[:message] || "is not verify") unless record.send(column_name) == value
          end
        end

      end
    end
  end
end
