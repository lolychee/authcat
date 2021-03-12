require "active_model/validator"

module Authcat
  module Identity
    module Validators
      class IdentifyValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          klass = case options[:with]
          when nil
            reload = true
            record.class
          when Symbol
            if options[:class_name]
              options[:class_name].constantize
            else
              reflection = record.class.reflect_on_association(options[:with])
              if reflection
                reflection.klass
              else
                record.errors.add(attribute, :invalid, strict: true, message: "#{options[:with].inspect} is not an association, please set class_name: ")
                return
              end
            end
          end

          identity =
            if options[:fuzzy]
              klass.identify(value)
            else
              klass.identify({ attribute => value })
            end

          if identity
            if reload
              reload(record, identity)
            else
              record.send("#{options[:with]}=", identity)
            end
          else
            record.errors.add(attribute, :not_found, **options.slice(:message))
          end
        end

        def new_reload(original, found)
          original.instance_variable_set(:@attributes, found.instance_variable_get(:@attributes))
          original.instance_variable_set(:@new_record, false)
          original.instance_variable_set(:@previously_new_record, false)

          original
        end

        def reload(original, found)
          changes = original.changes.map {|k, v| [k, v.last] }.to_h
          # FIX: original.attribute_was bug; ActiveModel::Dirty related
          original.clear_changes_information

          coder = {}
          found.encode_with(coder)
          original.init_with(coder)
          original.attributes = changes
        end
      end
    end
  end
end
