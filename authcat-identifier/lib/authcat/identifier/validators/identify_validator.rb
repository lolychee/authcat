require "active_model/validator"

module Authcat
  module Identifier
    module Validators
      class IdentifyValidator < ActiveModel::EachValidator
        def initialize(options)
          klass =
            case options[:with]
            when nil
              reload = true
              options[:class]
            when Symbol
              if options[:class_name]
                options[:class_name].constantize
              else
                reflection = options[:class].reflect_on_association(options[:with])
                if reflection
                  reflection.klass
                else
                  raise ArgumentError, "#{options[:with].inspect} is not an association, please set class_name: "
                end
              end
            end

          raise ArgumentError, "#{klass.name} undefined singleton method 'identify'" unless klass.respond_to?(:identify)

          super(options.merge(klass: klass, reload: reload))
        end

        def validate_each(record, attribute, value)
          identity =
            if options[:fuzzy_match]
              options[:klass].identify(value)
            else
              options[:klass].identify({ attribute => value })
            end

          if identity
            if options[:reload]
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
