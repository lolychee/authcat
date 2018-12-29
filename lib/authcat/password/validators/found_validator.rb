# frozen_string_literal: true

module Authcat
  module Password
    module Validators
      if defined?(ActiveModel) && defined?(ActiveModel::EachValidator)

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
              changes = record.changes.map {|k, v| [k, v.last] }.to_h
              # FIX: record.attribute_was bug; ActiveModel::Dirty related
              record.clear_changes_information

              coder = {}
              found.encode_with(coder)
              record.init_with(coder)
              record.attributes = changes
            end

            record.errors[attribute] << (options[:message] || "is not found") unless found
          end
        end

      end
    end
  end
end
