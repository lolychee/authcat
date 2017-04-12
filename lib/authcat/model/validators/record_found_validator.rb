module Authcat
  module Model
    module Validators
      class RecordFoundValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          klass = record.class

          user = klass.try("find_by_#{attribute}", value) || klass.find_by(attribute => value)

          if user
            record.instance_variable_set("@attributes", user.instance_variable_get("@attributes"))
            record.instance_variable_set("@new_record", false)
          else
            record.errors.add(attribute, "not found")
          end
        end
      end
    end
  end
end
