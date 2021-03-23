require "active_model/validator"

module Authcat
  class Password
    module Validators
      class AuthenticateValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          passed =
            if record.respond_to?(:authenticate)
              record.authenticate({ options[:with] => value })
            else
              !value.nil? && record.send(options[:with]) == value
            end

          record.errors.add(attribute, :incorrect, **options.slice(:message)) unless passed
        end
      end
    end
  end
end
