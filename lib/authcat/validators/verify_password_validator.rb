module Authcat
  module Validators
    class VerifyPasswordValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        record.errors.add(attribute, "not match") unless record.verify_password(options.fetch(:with) { :"#{attribute}_digest" }, value)
      end
    end
  end
end
