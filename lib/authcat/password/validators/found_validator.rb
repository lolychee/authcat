# frozen_string_literal: true

module Authcat
  module Password
    module Validators
      class FoundValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          klass = record.class
          find_method_name = "find_by_#{attribute}"

          found = if klass.respond_to?(find_method_name)
            klass.send(find_method_name, value)
          else
            klass.find_by(attribute => value)
          end

          if found
            changes = record.changed_attributes
            coder = {}
            found.encode_with(coder)
            record.init_with(coder)
            record.attributes = changes

            # FIX: record.attribute_was bug; ActiveModel::Dirty related
            record.instance_variable_set(:@mutations_from_database, nil)
          end

          record.errors[attribute] << (options[:message] || "is not found") unless found
        end
      end
    end
  end
end
