module Authcat
  module Identity
    module Identifier
      def self.setup(base)
        base.include self
      end

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def identifiers
          @identifiers ||= Hash.new {|_, key| raise ArgumentError, "Unknown identifier: #{key.inspect}" }
        end

        def identifier(attribute, **opts, &block)
          block ||= -> (value) { find_by(attribute => value) }
          identifiers[attribute] = opts.merge(finder: block)
        end

        def find_by_identifier(attributes = {}, &block)
          finders = if attributes.is_a?(Hash)
            attributes.map { |attribute, id| [identifiers[attribute], value] }
          else
            identifiers.map { |attribute, opts| [opts, attributes] }
          end

          finders.each do |opts, value|
            next unless opts[:format] =~ value.to_s
            found = self.instance_exec(value, &opts[:finder])
            return found if found
          end
          new.tap(&block) if block_given?
        end
      end

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
